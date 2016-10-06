//
//  BNRQuizViewController.m
//  Quiz
//
//  Created by 洪龙通 on 2016/10/6.
//  Copyright © 2016年 洪龙通. All rights reserved.
//

#import "BNRQuizViewController.h"

@interface BNRQuizViewController ()
@property (nonatomic, assign) int currentQuestionIndex;
@property (nonatomic, copy) NSArray *answers;
@property (nonatomic, copy) NSArray *questions;

@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UILabel *answerLabel;

@end

@implementation BNRQuizViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // Call the init method implemented by the superclass
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Create two arrays filled with questions and answers
        // and make the pointers point to them
        
        self.questions = @[@"From what is cognac made?",
                           @"What is 7+7?",
                           @"What is the capital of Vermont?"];
        
        self.answers = @[@"Grapes",
                         @"14",
                         @"Montpelier"];
    }
    
    // Return the address of the new object
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)showQuestionButtonPressed:(UIButton *)sender
{
    // Step to the next question
    self.currentQuestionIndex++;
    
    // Am I pas the last question?
    if (self.currentQuestionIndex == [self.questions count]) {
        
        // Go back to the first question
        self.currentQuestionIndex = 0;
    }
    
    // Get the string at the index in the questions array
    NSString *question = self.questions[self.currentQuestionIndex];
    
    CGRect originalFrame = self.questionLabel.frame;
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromRight
                     animations:^{
                         CGFloat x = self.view.frame.size.width;
                         self.questionLabel.frame = (CGRect){x, originalFrame.origin.y, originalFrame.size};
                         self.questionLabel.alpha = 0.0;

                     } completion:^(BOOL finished) {
                         
                         CGFloat x = -self.view.frame.size.width;
                         self.questionLabel.frame = (CGRect){x, originalFrame.origin.y, originalFrame.size};
                         
                         // Display the string in the question label
                         self.questionLabel.text = question;

                         // Reset the answer label
                         self.answerLabel.text = @"???";
                         [UIView animateWithDuration:0.3 delay:0
                                             options:UIViewAnimationOptionTransitionFlipFromLeft
                                          animations:^{
                                              self.questionLabel.frame = originalFrame;
                                              self.questionLabel.alpha = 1.0;
                                          } completion:NULL];
                         
                     }];
    
    
}

- (IBAction)showAnswerButtonPressed:(UIButton *)sender
{
    // What is the answer to the current question?
    NSString *answer = self.answers[self.currentQuestionIndex];
    
    CGRect originalFrame = self.answerLabel.frame;
    
    [UIView animateWithDuration:0.5
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromRight
                     animations:^{
                         CGFloat x = self.view.frame.size.width;
                         self.answerLabel.frame = (CGRect){x, originalFrame.origin.y, originalFrame.size};
                         self.answerLabel.alpha = 0.0;
                         
                     } completion:^(BOOL finished) {
                         
                         CGFloat x = -self.view.frame.size.width;
                         self.answerLabel.frame = (CGRect){x, originalFrame.origin.y, originalFrame.size};
                         
                         // Display it in the answer label
                         self.answerLabel.text = answer;
                         
                         [UIView animateWithDuration:0.3 delay:0
                                             options:UIViewAnimationOptionTransitionFlipFromLeft
                                          animations:^{
                                              self.answerLabel.frame = originalFrame;
                                              self.answerLabel.alpha = 1.0;
                                          } completion:NULL];
                         
                     }];
    
    
}


@end
