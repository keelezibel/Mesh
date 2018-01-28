package com.test.mesh3;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.ImageView;
import android.provider.MediaStore;
import android.os.Environment;
import android.net.Uri;
import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;
import android.graphics.drawable.BitmapDrawable;
import android.database.Cursor;
import android.provider.MediaStore.Images.Media;

import com.test.mesh3.entities.Message;
import com.test.mesh3.entities.Peer;
import com.bridgefy.sdk.client.BFEngineProfile;
import com.bridgefy.sdk.client.Bridgefy;


import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Date;
import java.io.File;
import java.text.SimpleDateFormat;
import java.io.InputStream;
import java.io.IOException;
import java.io.ByteArrayOutputStream;
import java.nio.ByteBuffer;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

import static com.test.mesh3.MainActivity.BROADCAST_CHAT;
import static com.test.mesh3.MainActivity.INTENT_EXTRA_NAME;
import static com.test.mesh3.MainActivity.INTENT_EXTRA_UUID;


public class ChatActivity extends AppCompatActivity {

    private String conversationName;
    private String conversationId;
    private Uri file;
    public static final int CAMERA_REQUEST = 100;
    public static final int GALLERY_REQUEST = 200;

    @BindView(R.id.txtMessage)
    EditText txtMessage;

    MessagesRecyclerViewAdapter messagesAdapter =
            new MessagesRecyclerViewAdapter(new ArrayList<Message>());


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_chat);
        ButterKnife.bind(this);

        // recover our Peer object
        conversationName = getIntent().getStringExtra(INTENT_EXTRA_NAME);
        conversationId   = getIntent().getStringExtra(INTENT_EXTRA_UUID);

        // Configure the Toolbar
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        // Enable the Up button
        ActionBar ab = getSupportActionBar();
        if (ab != null) {
            ab.setTitle(conversationName);
            ab.setDisplayHomeAsUpEnabled(true);
        }

        // register the receiver to listen for incoming messages
        LocalBroadcastManager.getInstance(getBaseContext())
                .registerReceiver(new BroadcastReceiver() {
                    @Override
                    public void onReceive(Context context, Intent intent) {
                        byte[] img = intent.getByteArrayExtra(MainActivity.INTENT_EXTRA_IMG);
                        // Empty byte[]
                        if(img.length == 0){
                            Message message = new Message(intent.getStringExtra(MainActivity.INTENT_EXTRA_MSG),null);
                            message.setDeviceName(intent.getStringExtra(MainActivity.INTENT_EXTRA_NAME));
                            message.setDirection(Message.INCOMING_MESSAGE);
                            messagesAdapter.addMessage(message);
                        }
                        // Non-Empty byte[]
                        else {
                            Message message = new Message(intent.getStringExtra(MainActivity.INTENT_EXTRA_MSG),intent.getByteArrayExtra(MainActivity.INTENT_EXTRA_IMG));
                            message.setDeviceName(intent.getStringExtra(MainActivity.INTENT_EXTRA_NAME));
                            message.setDirection(Message.INCOMING_MESSAGE);
                            messagesAdapter.addMessage(message);
                        }
                    }
                }, new IntentFilter(conversationId));

        // configure the recyclerview
        RecyclerView messagesRecyclerView = (RecyclerView) findViewById(R.id.message_list);
        LinearLayoutManager mLinearLayoutManager = new LinearLayoutManager(this);
        mLinearLayoutManager.setReverseLayout(true);
        messagesRecyclerView.setLayoutManager(mLinearLayoutManager);
        messagesRecyclerView.setAdapter(messagesAdapter);
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
    }


    @OnClick({R.id.btnSend})
    public void onMessageSend(View v) {
        // get the message and push it to the views
        String messageString = txtMessage.getText().toString();
        if (messageString.trim().length() > 0) {
            // update the views
            txtMessage.setText("");
            Message message = new Message(messageString, null);
            message.setDirection(Message.OUTGOING_MESSAGE);
            messagesAdapter.addMessage(message);

            // create a HashMap object to send
            HashMap<String, Object> content = new HashMap<>();
            content.put("text", messageString);

            // send message text to device
            if (conversationId.equals(BROADCAST_CHAT)) {
                // we put extra information in broadcast packets since they won't be bound to a session
                content.put("device_name", Build.MANUFACTURER + " " + Build.MODEL);
                content.put("device_type", Peer.DeviceType.ANDROID.ordinal());

                com.bridgefy.sdk.client.Message.Builder builder=new com.bridgefy.sdk.client.Message.Builder();
                builder.setContent(content);
                Bridgefy.sendBroadcastMessage(builder.build(),
                        BFEngineProfile.BFConfigProfileLongReach);
                /*
                Bridgefy.sendBroadcastMessage(
                        Bridgefy.createMessage(content),
                        BFEngineProfile.BFConfigProfileLongReach);
                */

            } else {
                /*
                Bridgefy.sendMessage(
                        Bridgefy.createMessage(conversationId, content),
                        BFEngineProfile.BFConfigProfileLongReach);
                */
                com.bridgefy.sdk.client.Message.Builder builder=new com.bridgefy.sdk.client.Message.Builder();
                builder.setContent(content).setReceiverId(conversationId);

                Bridgefy.sendMessage(builder.build(),
                        BFEngineProfile.BFConfigProfileLongReach);
            }
        }
    }

    @OnClick({R.id.Camera})
    public void openCamera(View v){
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        file = Uri.fromFile(getOutputMediaFile());
        intent.putExtra(MediaStore.EXTRA_OUTPUT, file);

        startActivityForResult(intent,CAMERA_REQUEST);
    }

    @OnClick({R.id.Gallery})
    public void openGallery(View v){
        Intent photoPickerIntent = new Intent(Intent.ACTION_GET_CONTENT);
        photoPickerIntent.setType("image/*");

        startActivityForResult(Intent.createChooser(photoPickerIntent,"Select Picture"),GALLERY_REQUEST);
    }

    byte[] imgData = null;
    private Uri imageUri;
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch (requestCode) {
            case GALLERY_REQUEST:
                if (resultCode == Activity.RESULT_OK && data != null && data.getData() != null) {
                    Uri selectedImageUri = data.getData();
                    try {
                        InputStream imageStream = getContentResolver().openInputStream(selectedImageUri);
                        Bitmap reducedSizeBitmap = getBitmap(selectedImageUri,imageStream);

                        byte[] arr = convertBitmapToByteArray(reducedSizeBitmap);
                        Message message = new Message("", arr);
                        message.setDirection(Message.OUTGOING_MESSAGE);
                        messagesAdapter.addMessage(message);

                        // create a HashMap object to send
                        HashMap<String, Object> content = new HashMap<>();
                        content.put("text", null);

                        // send message text to device
                        if (conversationId.equals(BROADCAST_CHAT)) {

                        } else {
                            com.bridgefy.sdk.client.Message.Builder builder=new com.bridgefy.sdk.client.Message.Builder();
                            //builder.setContent(content).setReceiverId(conversationId);
                            builder.setData(arr).setReceiverId(conversationId);

                            Bridgefy.sendMessage(builder.build(),
                                    BFEngineProfile.BFConfigProfileLongReach);
                        }
                    }
                    catch (FileNotFoundException e){
                        throw new RuntimeException(e);
                    }
                }
                return;

            case CAMERA_REQUEST:
                if (resultCode == Activity.RESULT_OK) {
                    Uri img = file;
                    getContentResolver().notifyChange(file, null);
                    Uri uri = Uri.fromFile(new File(file.getPath()));
                    Bitmap reducedSizeBitmap = getBitmap(uri,null);

                    byte[] arr = convertBitmapToByteArray(reducedSizeBitmap);
                    Message message = new Message("", arr);
                    message.setDirection(Message.OUTGOING_MESSAGE);
                    messagesAdapter.addMessage(message);

                    // create a HashMap object to send
                    HashMap<String, Object> content = new HashMap<>();
                    content.put("text", "");

                    // send message text to device
                    if (conversationId.equals(BROADCAST_CHAT)) {

                    } else {
                        com.bridgefy.sdk.client.Message.Builder builder=new com.bridgefy.sdk.client.Message.Builder();
                        //builder.setContent(content).setReceiverId(conversationId);
                        builder.setData(arr).setReceiverId(conversationId);

                        Bridgefy.sendMessage(builder.build(),
                                BFEngineProfile.BFConfigProfileLongReach);
                    }

                }
                return;
        }
    }

    public byte[] convertBitmapToByteArray(Bitmap bmp){
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        bmp.compress(Bitmap.CompressFormat.PNG, 100, stream);
        byte[] byteArray = stream.toByteArray();

        return byteArray;
    }

    public byte[] getBytes(InputStream inputStream) throws IOException {
        ByteArrayOutputStream byteBuffer = new ByteArrayOutputStream();
        int bufferSize = 1024;
        byte[] buffer = new byte[bufferSize];

        int len = 0;
        while ((len = inputStream.read(buffer)) != -1) {
            byteBuffer.write(buffer, 0, len);
        }
        return byteBuffer.toByteArray();
    }

    private static File getOutputMediaFile(){
        File mediaStorageDir = new File(Environment.getExternalStorageDirectory(), "MeshDemo");

        if (!mediaStorageDir.exists()){
            mediaStorageDir.mkdirs();
        }

        String timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
        return new File(mediaStorageDir.getPath() + File.separator +
                "IMG_"+ timeStamp + ".png");
    }

    // Resize image to certain MP
    private Bitmap getBitmap(Uri inUri, InputStream inStream) {

        Uri uri = inUri;
        InputStream in = inStream;
        try {
            final int IMAGE_MAX_SIZE = 8000; // 1.2MP
            in = getContentResolver().openInputStream(uri);

            // Decode image size
            BitmapFactory.Options o = new BitmapFactory.Options();
            o.inJustDecodeBounds = true;
            BitmapFactory.decodeStream(in, null, o);
            in.close();


            int scale = 1;
            while ((o.outWidth * o.outHeight) * (1 / Math.pow(scale, 2)) >
                    IMAGE_MAX_SIZE) {
                scale++;
            }
            Log.d("", "scale = " + scale + ", orig-width: " + o.outWidth + ", orig-height: " + o.outHeight);

            Bitmap b = null;
            in = getContentResolver().openInputStream(uri);
            if (scale > 1) {
                scale--;
                // scale to max possible inSampleSize that still yields an image
                // larger than target
                o = new BitmapFactory.Options();
                o.inSampleSize = scale;
                b = BitmapFactory.decodeStream(in, null, o);

                // resize to desired dimensions
                int height = b.getHeight();
                int width = b.getWidth();
                Log.d("", "1th scale operation dimenions - width: " + width + ", height: " + height);

                double y = Math.sqrt(IMAGE_MAX_SIZE
                        / (((double) width) / height));
                double x = (y / height) * width;

                Bitmap scaledBitmap = Bitmap.createScaledBitmap(b, (int) x,
                        (int) y, true);
                b.recycle();
                b = scaledBitmap;

                System.gc();
            } else {
                b = BitmapFactory.decodeStream(in);
            }
            in.close();

            Log.d("", "bitmap size - width: " + b.getWidth() + ", height: " +
                    b.getHeight());
            return b;
        } catch (IOException e) {
            Log.e("", e.getMessage(), e);
            return null;
        }
    }


    /**
     *      RECYCLER VIEW CLASSES
     */
    class MessagesRecyclerViewAdapter
            extends RecyclerView.Adapter<MessagesRecyclerViewAdapter.MessageViewHolder> {

        private final List<Message> messages;

        MessagesRecyclerViewAdapter(List<Message> messages) {
            this.messages = messages;
        }

        @Override
        public int getItemCount() {
            return messages.size();
        }

        void addMessage(Message message) {
            messages.add(0, message);
            notifyDataSetChanged();
        }

        @Override
        public int getItemViewType(int position) {
            return messages.get(position).getDirection();
        }

        @Override
        public MessageViewHolder onCreateViewHolder(ViewGroup viewGroup, int viewType) {
            View messageView = null;

            switch (viewType) {
                case Message.INCOMING_MESSAGE:
                    messageView = LayoutInflater.from(viewGroup.getContext()).
                            inflate((R.layout.message_row_incoming), viewGroup, false);
                    break;
                case Message.OUTGOING_MESSAGE:
                    messageView = LayoutInflater.from(viewGroup.getContext()).
                            inflate((R.layout.message_row_outgoing), viewGroup, false);
                    break;
            }

            return new MessageViewHolder(messageView);
        }

        @Override
        public void onBindViewHolder(final MessageViewHolder messageHolder, int position) {
            messageHolder.setMessage(messages.get(position));
        }

        class MessageViewHolder extends RecyclerView.ViewHolder {
            final TextView txtMessage;

            Message message;

            MessageViewHolder(View view) {
                super(view);
                txtMessage = (TextView) view.findViewById(R.id.txtMessage);
            }

            void setMessage(Message message) {
                this.message = message;

                if (message.getDirection() == Message.INCOMING_MESSAGE &&
                        conversationId.equals(BROADCAST_CHAT)) {
                    this.txtMessage.setText(message.getDeviceName() + ":\n" + message.getText());
                } else {
                    if(message.getImage() != null){
                        byte[] imgMsg = message.getImage();
                        Bitmap img = BitmapFactory.decodeByteArray(imgMsg, 0, imgMsg.length);
                        BitmapDrawable drawableLeft = new BitmapDrawable(getResources(), img);
                        this.txtMessage.setCompoundDrawablesWithIntrinsicBounds(drawableLeft, null, null, null);
                    }
                    this.txtMessage.setText(message.getText());
                }
            }
        }
    }
}
