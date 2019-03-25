//
//  MapPerson.m
//  ChatSample
//

#import "MapPerson.h"

@implementation MapPerson

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)updateCellWithTitle:(NSString *)title description:(NSString *)desc{
    self.descPerson.text = desc;
    self.titlePerson.text = title;
}

/*
-(void)updateCellWithTitle:(NSString *)title description:(NSString *)desc image:(NSString *)img{
    //self.imgPerson.image = [UIImage imageNamed:img];
    self.descPerson.text = desc;
    self.titlePerson.text = title;
}
*/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
