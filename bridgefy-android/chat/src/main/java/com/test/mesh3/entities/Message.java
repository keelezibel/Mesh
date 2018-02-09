package com.test.mesh3.entities;

import android.graphics.BitmapFactory;

import com.google.gson.Gson;
import android.graphics.Bitmap;

/**
 * @author dekaru on 5/9/17.
 */

public class Message {

    public final static int INCOMING_MESSAGE = 0;
    public final static int OUTGOING_MESSAGE = 1;

    private int    direction;
    private String deviceName;
    private String text;
    private byte[] image;

    public Message(String text, byte[] image) {
        this.text = text;
        this.image = image;
    }

    public int getDirection() {
        return direction;
    }

    public void setDirection(int direction) {
        this.direction = direction;
    }

    public String getDeviceName() {
        return deviceName;
    }

    public String getText() {
        return text;
    }

    public byte[] getImage() {
        return image;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }


    public static Message create(String json) {
        return new Gson().fromJson(json, Message.class);
    }

    @Override
    public String toString() {
        return new Gson().toJson(this);
    }
}
