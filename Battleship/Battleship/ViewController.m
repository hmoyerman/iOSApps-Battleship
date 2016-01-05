// 
//   ViewController.m
//   Battleship
// 
//   Created by Henry Moyerman on 10/16/15.
//   Copyright (c) 2015 Henry Moyerman. All rights reserved.
// 

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()
{
    AVAudioPlayer *sinkSound;
    AVAudioPlayer *winSound;
    AVAudioPlayer *loseSound;
}
@end

@implementation ViewController
@synthesize onePlayer;
@synthesize playerTurn;
@synthesize goesFirst;
@synthesize endGame;
@synthesize SALVO;
@synthesize randomPlay;
@synthesize attackReady;
@synthesize ARM;
@synthesize p1ShipsSet;
@synthesize p2ShipsSet;
@synthesize hitShip;
@synthesize attackTile;
@synthesize originHit;
@synthesize currentHit;
@synthesize hitDirection;
@synthesize aiOffset;
@synthesize randomShips;

@synthesize p1hitCounter;
@synthesize p2hitCounter;
@synthesize p1shipHitCounter;
@synthesize p2shipHitCounter;

@synthesize topGrid;
@synthesize bottomGrid;
@synthesize p1guesses;
@synthesize p2guesses;
@synthesize p1board;
@synthesize p2board;
@synthesize names;

@synthesize p1ship1;
@synthesize p1ship2;
@synthesize p1ship3;
@synthesize p1ship4;
@synthesize p1ship5;
@synthesize p2ship1;
@synthesize p2ship2;
@synthesize p2ship3;
@synthesize p2ship4;
@synthesize p2ship5;

@synthesize p1ship1Counter;
@synthesize p1ship2Counter;
@synthesize p1ship3Counter;
@synthesize p1ship4Counter;
@synthesize p1ship5Counter;
@synthesize p2ship1Counter;
@synthesize p2ship2Counter;
@synthesize p2ship3Counter;
@synthesize p2ship4Counter;
@synthesize p2ship5Counter;

@synthesize notEmptyAlert;
@synthesize mainTitle;
@synthesize guessesTitle;
@synthesize boardTitle;
@synthesize hitTitle;

@synthesize ship1;
@synthesize ship2;
@synthesize ship3;
@synthesize ship4;
@synthesize ship5;
@synthesize blanket;
@synthesize dropRotateBox;
@synthesize attackButton;
@synthesize allShipsSet;
@synthesize selectedShip;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initStart];
    UIAlertView *welcomeAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Welcome to Batteship!"
                                 message:@"Build by Henry Moyerman"
                                 delegate:self
                                 cancelButtonTitle:@"Play"
                                 otherButtonTitles: nil];
    [welcomeAlert show];
}

- (void)initStart {
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    // creates top grid of app
    
    topGrid = [[NSMutableArray alloc] init];
    int initX = 30;
    int initY = 115;
    int x = initX;
    int y = initY;
    for( int i = 0; i < 100; i++ ) {
        if (i%10 == 0 && i != 0){
            x = initX;
            y += 20;
        }
        
        UIButton* aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        aButton.frame = CGRectMake(x, y, 19, 19);
        [aButton setTag:i];
        [self.view addSubview:aButton];
        [aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        aButton.backgroundColor = [UIColor blackColor];
        [aButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [topGrid addObject:aButton];
        x += 20;
    }
    
    
    // creates bottom grid of app
    
    bottomGrid = [[NSMutableArray alloc] init];
    int inity2 = 360;
    int y2 = inity2;
    x = initX;
    for( int i = 0; i < 100; i++ ) {
        if (i%10 == 0 && i != 0){
            x = initX;
            y2 += 20;
        }
        
        UILabel* aButton = [[UILabel alloc]initWithFrame:CGRectMake(x, y2, 19, 19)];
        [self.view addSubview:aButton];
        aButton.textColor = [UIColor blackColor];
        aButton.backgroundColor = [UIColor blackColor];
        aButton.textAlignment = NSTextAlignmentCenter;
        [bottomGrid addObject:aButton];
        x += 20;
    }
    
    
    // creates arrays for boards and guesses for each player
    
    typedef enum{E, H, M, S} battleEnum;
    p1guesses = [[NSMutableArray alloc] init];
    p2guesses = [[NSMutableArray alloc] init];
    p1board = [[NSMutableArray alloc] init];
    p2board = [[NSMutableArray alloc] init];
    for( int i = 0; i < 100; i++ ) {
        [p1guesses addObject:@(E)];
        [p2guesses addObject:@(E)];
        [p1board addObject:@(E)];
        [p2board addObject:@(E)];
    }
    
    
    // creates an array with a refernce for the name of a tile that mtches the index
    
    names = [[NSMutableArray alloc] init];
    for( int i = 0; i < 10; i++ ) {
        for( int j = 0; j < 10; j++ ){
            if (j == 0) {NSString *s = [NSString stringWithFormat:@"A%i", i+1]; [names addObject: s];}
            if (j == 1) {NSString *s = [NSString stringWithFormat:@"B%i", i+1]; [names addObject: s];}
            if (j == 2) {NSString *s = [NSString stringWithFormat:@"C%i", i+1]; [names addObject: s];}
            if (j == 3) {NSString *s = [NSString stringWithFormat:@"D%i", i+1]; [names addObject: s];}
            if (j == 4) {NSString *s = [NSString stringWithFormat:@"E%i", i+1]; [names addObject: s];}
            if (j == 5) {NSString *s = [NSString stringWithFormat:@"F%i", i+1]; [names addObject: s];}
            if (j == 6) {NSString *s = [NSString stringWithFormat:@"G%i", i+1]; [names addObject: s];}
            if (j == 7) {NSString *s = [NSString stringWithFormat:@"H%i", i+1]; [names addObject: s];}
            if (j == 8) {NSString *s = [NSString stringWithFormat:@"I%i", i+1]; [names addObject: s];}
            if (j == 9) {NSString *s = [NSString stringWithFormat:@"J%i", i+1]; [names addObject: s];}
        }
    }
    
    [self makeLabels1];
    [self makeLabels2];
    
    
    // creates the arrays the represent all 10 ships
    
    p1ship1 = [[NSMutableArray alloc] initWithObjects:
               @1, @"Destroyer", @100, @101, nil];
    p1ship2 = [[NSMutableArray alloc] initWithObjects:
               @2, @"Submarine", @102, @103, @104, nil];
    p1ship3 = [[NSMutableArray alloc] initWithObjects:
               @3, @"Cruiser", @105, @106, @107, nil];
    p1ship4 = [[NSMutableArray alloc] initWithObjects:
               @4, @"Battleship", @108, @109, @110, @111, nil];
    p1ship5 = [[NSMutableArray alloc] initWithObjects:
               @5, @"Carrier", @112, @113, @114, @115, @116, nil];
    p2ship1 = [[NSMutableArray alloc] initWithObjects:
               @1, @"Destroyer", @100, @101, nil];
    p2ship2 = [[NSMutableArray alloc] initWithObjects:
               @2, @"Submarine", @102, @103, @104, nil];
    p2ship3 = [[NSMutableArray alloc] initWithObjects:
               @3, @"Cruiser", @105, @106, @107, nil];
    p2ship4 = [[NSMutableArray alloc] initWithObjects:
               @4, @"Battleship", @108, @109, @110, @111, nil];
    p2ship5 = [[NSMutableArray alloc] initWithObjects:
               @5, @"Carrier", @112, @113, @114, @115, @116, nil];
    
    notEmptyAlert = [[UIAlertView alloc]
                     initWithTitle:@"Pick an empty box"
                     message:@"This box has already been played"
                     delegate:self
                     cancelButtonTitle:@"OK"
                     otherButtonTitles: nil];
    
    
    // creates all labels and button for app
    
    mainTitle = [[UILabel alloc]initWithFrame:CGRectMake(5, 20, 200, 40)];
    [mainTitle setFont:[UIFont systemFontOfSize:30]];
    mainTitle.text = @"Battleship";
    mainTitle.numberOfLines = 1;
    mainTitle.backgroundColor = [UIColor clearColor];
    mainTitle.textColor = [UIColor blackColor];
    mainTitle.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:mainTitle];
    
    hitTitle = [[UILabel alloc]initWithFrame:CGRectMake(30, 60, 200, 25)];
    [hitTitle setFont:[UIFont systemFontOfSize:17]];
    hitTitle.text = @"";
    hitTitle.numberOfLines = 1;
    hitTitle.backgroundColor = [UIColor clearColor];
    hitTitle.textColor = [UIColor redColor];
    hitTitle.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:hitTitle];
    
    guessesTitle = [[UILabel alloc]initWithFrame:CGRectMake(30, 80, 200, 25)];
    [guessesTitle setFont:[UIFont systemFontOfSize:17]];
    guessesTitle.text = @"";
    guessesTitle.numberOfLines = 1;
    guessesTitle.backgroundColor = [UIColor clearColor];
    guessesTitle.textColor = [UIColor blackColor];
    guessesTitle.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:guessesTitle];
    
    boardTitle = [[UILabel alloc]initWithFrame:CGRectMake(30, 325, 200, 25)];
    [boardTitle setFont:[UIFont systemFontOfSize:17]];
    boardTitle.text = @"";
    boardTitle.numberOfLines = 1;
    boardTitle.backgroundColor = [UIColor clearColor];
    boardTitle.textColor = [UIColor blackColor];
    boardTitle.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:boardTitle];
    
    UIButton* newGameOption = [UIButton buttonWithType:UIButtonTypeCustom];
    newGameOption.frame = CGRectMake(200, 25, 100, 20);
    [self.view addSubview:newGameOption];
    [newGameOption setTitle: @"New Game" forState: UIControlStateNormal];
    [newGameOption setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    newGameOption.backgroundColor = [UIColor clearColor];
    [newGameOption addTarget:self action:@selector(newGameButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    attackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    attackButton.frame = CGRectMake(200, 65, 100, 30);
    [self.view addSubview:attackButton];
    [attackButton setTitle: @"ATTACK!!" forState: UIControlStateNormal];
    [attackButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    attackButton.backgroundColor = [UIColor clearColor];
    [attackButton addTarget:self action:@selector(attackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    attackButton.hidden = true;
    
    allShipsSet = [UIButton buttonWithType:UIButtonTypeCustom];
    allShipsSet.frame = CGRectMake(200, 65, 100, 30);
    [self.view addSubview:allShipsSet];
    [allShipsSet setTitle: @"Lock Ships" forState: UIControlStateNormal];
    [allShipsSet setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    allShipsSet.backgroundColor = [UIColor clearColor];
    [allShipsSet addTarget:self action:@selector(allShipButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    allShipsSet.hidden = true;
    
    
    // to cover up the top grid during ship selection
    
    blanket = [[UILabel alloc]initWithFrame:CGRectMake(15, 100, 215, 220)];
    blanket.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:blanket];
    blanket.hidden = false;
    
    dropRotateBox = [[UILabel alloc]initWithFrame:CGRectMake(30, 270, 60, 60)];
    [dropRotateBox setFont:[UIFont systemFontOfSize:15]];
    dropRotateBox.text = @"Drop Here to Rotate";
    dropRotateBox.numberOfLines = 3;
    dropRotateBox.backgroundColor = [UIColor whiteColor];
    dropRotateBox.textColor = [UIColor blackColor];
    dropRotateBox.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:dropRotateBox];
    dropRotateBox.hidden = true;
    
    
    // creates ships for manual placement mode
    
    ship1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 19, 39)];
    [ship1 setFont:[UIFont systemFontOfSize:10]];
    ship1.text = @"v";
    ship1.numberOfLines = 1;
    ship1.backgroundColor = [UIColor grayColor];
    ship1.textColor = [UIColor clearColor];
    [self.view addSubview:ship1];
    ship1.hidden = true;
    
    ship2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 19, 59)];
    [ship2 setFont:[UIFont systemFontOfSize:10]];
    ship2.text = @"v";
    ship2.numberOfLines = 1;
    ship2.backgroundColor = [UIColor grayColor];
    ship2.textColor = [UIColor clearColor];
    [self.view addSubview:ship2];
    ship2.hidden = true;
    
    ship3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 19, 59)];
    [ship3 setFont:[UIFont systemFontOfSize:10]];
    ship3.text = @"v";
    ship3.numberOfLines = 1;
    ship3.backgroundColor = [UIColor grayColor];
    ship3.textColor = [UIColor clearColor];
    [self.view addSubview:ship3];
    ship3.hidden = true;
    
    ship4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 19, 79)];
    [ship4 setFont:[UIFont systemFontOfSize:10]];
    ship4.text = @"v";
    ship4.numberOfLines = 1;
    ship4.backgroundColor = [UIColor grayColor];
    ship4.textColor = [UIColor clearColor];
    [self.view addSubview:ship4];
    ship4.hidden = true;
    
    ship5 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 19, 99)];
    [ship5 setFont:[UIFont systemFontOfSize:10]];
    ship5.text = @"v";
    ship5.numberOfLines = 1;
    ship5.backgroundColor = [UIColor grayColor];
    ship5.textColor = [UIColor clearColor];
    [self.view addSubview:ship5];
    ship5.hidden = true;
    
    
    // initalize sounds for game
    
    NSString *path = [NSString stringWithFormat:@"%@/sink.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    sinkSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    
    path = [NSString stringWithFormat:@"%@/win.mp3", [[NSBundle mainBundle] resourcePath]];
    soundUrl = [NSURL fileURLWithPath:path];
    winSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    
    path = [NSString stringWithFormat:@"%@/lose.mp3", [[NSBundle mainBundle] resourcePath]];
    soundUrl = [NSURL fileURLWithPath:path];
    loseSound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
    
}

- (void)makeLabels1 {
    
    // makes the A-J labels for grids
    
    NSString *s = @"";
    int initX = 36;
    int x = initX;
    int y = 105;
    int y2 = 350;
    for (int i = 0; i<10; i++) {
        if (i == 0) {s = @"A";}
        if (i == 1) {s = @"B";}
        if (i == 2) {s = @"C";}
        if (i == 3) {s = @"D";}
        if (i == 4) {s = @"E";}
        if (i == 5) {s = @"F";}
        if (i == 6) {s = @"G";}
        if (i == 7) {s = @"H";}
        if (i == 8) {s = @"I";}
        if (i == 9) {s = @"J";}
        
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 10, 10)];
        [label1 setFont:[UIFont systemFontOfSize:10]];
        label1.text = s;
        label1.numberOfLines = 1;
        label1.backgroundColor = [UIColor clearColor];
        label1.textColor = [UIColor blackColor];
        label1.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:label1];
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(x, y2, 10, 10)];
        
        [label2 setFont:[UIFont systemFontOfSize:10]];
        label2.text = s;
        label2.numberOfLines = 1;
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor blackColor];
        label2.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:label2];
        x += 20;
    }
}

- (void)makeLabels2 {
    
    // makes the 1-10 labels for grids
    
    NSString *s = @"";
    int y1 = 119;
    int y2 = 364;
    int x = 20;
    for (int i = 0; i<10; i++) {
        if (i == 9) {
            x = 17;
        }
        s = [NSString stringWithFormat:@"%i", i+1];
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(x, y1, 12, 10)];
        [label1 setFont:[UIFont systemFontOfSize:10]];
        label1.text = s;
        label1.numberOfLines = 1;
        label1.backgroundColor = [UIColor clearColor];
        label1.textColor = [UIColor blackColor];
        label1.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:label1];
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(x, y2, 12, 10)];
        
        [label2 setFont:[UIFont systemFontOfSize:10]];
        label2.text = s;
        label2.numberOfLines = 1;
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor blackColor];
        label2.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:label2];
        y1 += 20;
        y2 += 20;
    }
}

- (void)makeShips {
    
    // sets location of ships for manual placement
    
    dropRotateBox.hidden = false;
    
    [ship1 setTransform:CGAffineTransformMakeRotation(-M_PI / 1)];
    [ship1 setFrame:CGRectMake(50, 70, ship1.frame.size.width, ship1.frame.size.height)];
    ship1.text = @"v";
    
    [ship2 setTransform:CGAffineTransformMakeRotation(-M_PI / 1)];
    [ship2 setFrame:CGRectMake(90, 110, ship2.frame.size.width, ship2.frame.size.height)];
    ship2.text = @"v";
    
    [ship3 setTransform:CGAffineTransformMakeRotation(-M_PI / 1)];
    [ship3 setFrame:CGRectMake(130, 150, ship3.frame.size.width, ship3.frame.size.height)];
    ship3.text = @"v";
    
    [ship4 setTransform:CGAffineTransformMakeRotation(-M_PI / 1)];
    [ship4 setFrame:CGRectMake(170, 190, ship4.frame.size.width, ship4.frame.size.height)];
    ship4.text = @"v";
    
    [ship5 setTransform:CGAffineTransformMakeRotation(-M_PI / 1)];
    [ship5 setFrame:CGRectMake(210, 230, ship5.frame.size.width, ship5.frame.size.height)];
    ship5.text = @"v";
    
    ship1.hidden = false;
    ship2.hidden = false;
    ship3.hidden = false;
    ship4.hidden = false;
    ship5.hidden = false;
    
    [self hideTopGrid];
}

- (void)shipsAreSet {
    
    // when all ships are placed correcty on the bottom grid
    // this method will take the placement of the ships and enter it into the player's board
    // hides ships and other manual placement items
    
    typedef enum{E, H, M, S} battleEnum;
    
    dropRotateBox.hidden = true;
    
    ship1.hidden = true;
    ship2.hidden = true;
    ship3.hidden = true;
    ship4.hidden = true;
    ship5.hidden = true;
    
    
    if (playerTurn == true) {
        p1board[ [p1ship1[2] integerValue] ] = @(S);
        p1board[ [p1ship1[3] integerValue] ] = @(S);
        p1board[ [p1ship2[2] integerValue] ] = @(S);
        p1board[ [p1ship2[3] integerValue] ] = @(S);
        p1board[ [p1ship2[4] integerValue] ] = @(S);
        p1board[ [p1ship3[2] integerValue] ] = @(S);
        p1board[ [p1ship3[3] integerValue] ] = @(S);
        p1board[ [p1ship3[4] integerValue] ] = @(S);
        p1board[ [p1ship4[2] integerValue] ] = @(S);
        p1board[ [p1ship4[3] integerValue] ] = @(S);
        p1board[ [p1ship4[4] integerValue] ] = @(S);
        p1board[ [p1ship4[5] integerValue] ] = @(S);
        p1board[ [p1ship5[2] integerValue] ] = @(S);
        p1board[ [p1ship5[3] integerValue] ] = @(S);
        p1board[ [p1ship5[4] integerValue] ] = @(S);
        p1board[ [p1ship5[5] integerValue] ] = @(S);
        p1board[ [p1ship5[6] integerValue] ] = @(S);
    }
    else {
        p2board[ [p2ship1[2] integerValue] ] = @(S);
        p2board[ [p2ship1[3] integerValue] ] = @(S);
        p2board[ [p2ship2[2] integerValue] ] = @(S);
        p2board[ [p2ship2[3] integerValue] ] = @(S);
        p2board[ [p2ship2[4] integerValue] ] = @(S);
        p2board[ [p2ship3[2] integerValue] ] = @(S);
        p2board[ [p2ship3[3] integerValue] ] = @(S);
        p2board[ [p2ship3[4] integerValue] ] = @(S);
        p2board[ [p2ship4[2] integerValue] ] = @(S);
        p2board[ [p2ship4[3] integerValue] ] = @(S);
        p2board[ [p2ship4[4] integerValue] ] = @(S);
        p2board[ [p2ship4[5] integerValue] ] = @(S);
        p2board[ [p2ship5[2] integerValue] ] = @(S);
        p2board[ [p2ship5[3] integerValue] ] = @(S);
        p2board[ [p2ship5[4] integerValue] ] = @(S);
        p2board[ [p2ship5[5] integerValue] ] = @(S);
        p2board[ [p2ship5[6] integerValue] ] = @(S);
    }
    if (playerTurn == true) { p1ShipsSet = true; playerTurn = false; }
    else { p2ShipsSet = true; playerTurn = true;}
    [self clearGridText];
    [self startAlerts];
}

- (void)newGame {
    
    // resests anyting needed to start a new game
    
    dropRotateBox.hidden = true;
    ship1.hidden = true;
    ship2.hidden = true;
    ship3.hidden = true;
    ship4.hidden = true;
    ship5.hidden = true;
    
    [self resetBoardsandGuesses];
    [self clearGridText];
    blanket.hidden = false;
    endGame = false;
    p1ship1Counter = 2;
    p1ship2Counter = 3;
    p1ship3Counter = 3;
    p1ship4Counter = 4;
    p1ship5Counter = 5;
    p2ship1Counter = 2;
    p2ship2Counter = 3;
    p2ship3Counter = 3;
    p2ship4Counter = 4;
    p2ship5Counter = 5;
    p1hitCounter = 0;
    p2hitCounter = 0;
    p1shipHitCounter = 0;
    p2shipHitCounter = 0;
    hitDirection = 0;
    randomPlay = true;
    onePlayer = false;
    attackReady = false;
    p1ShipsSet = false;
    p2ShipsSet = false;
    randomShips = arc4random_uniform(20);
    UIAlertView *radarAlert = [[UIAlertView alloc]
                               initWithTitle:@"Would you like to play with Advanced Radar Mode?"
                               message:@"After ships placements have been set, this mode will automatically eliminate 10 empty squares"
                               delegate:self
                               cancelButtonTitle:nil
                               otherButtonTitles:@"ARM Off", @"ARM On", nil];
    
    [radarAlert show];
}

- (void)selectNumberOfPlayers {
    UIAlertView *numberPlayersAlert = [[UIAlertView alloc]
                                       initWithTitle:@"One or Two Player?"
                                       message:nil
                                       delegate:self
                                       cancelButtonTitle:nil
                                       otherButtonTitles:@"One", @"Two", nil];
    
    [numberPlayersAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // checks all items clicked in alerts, and does the corresponding action
    
    NSString *string = [alertView buttonTitleAtIndex:buttonIndex];
    if ([string isEqualToString:@"Yes"]) { [self newGame]; }
    if ([string isEqualToString:@"Play"]) { [self newGame]; }
    if ([string isEqualToString:@"Play Again?"]) { [self newGame]; }
    if ([string isEqualToString:@"ARM On"]) { ARM = true; [self selectNumberOfPlayers]; }
    if ([string isEqualToString:@"ARM Off"]) { ARM = false; [self selectNumberOfPlayers]; }
    if ([string isEqualToString:@"Let's Do This!"]) { [self populateGrids]; }
    if ([string isEqualToString:@"Set P1 Ships"]) { [self pickShipsForp1]; }
    if ([string isEqualToString:@"Set P2 Ships"]) { [self pickShipsForp2]; }
    if ([string isEqualToString:@"Orders Received"]) { [self populateGrids]; [self iPhonePlay]; }
    if ([string isEqualToString:@"Affirmitive"]) {
        if (onePlayer == false || playerTurn == false) { [self switchPlayer]; }
        else { [self populateGrids]; [self iPhonePlay]; }
    }
    // if ([string isEqualToString:@"Roger"]) { };
    if ([string isEqualToString:@"One"]) {
        onePlayer = true;
        aiOffset = arc4random_uniform(3);
        [self pickplayer];
        
    }
    if ([string isEqualToString:@"Two"]) {
        onePlayer = false;
        [self pickplayer];
    }
    if ([string isEqualToString:@"It's go time!"]) {
        [self showTopGrid];
        blanket.hidden = true;
        if (ARM == true) {
            [self runARM];
        }
        if (onePlayer == true && playerTurn == false) { [self iPhonePlay]; }
        else { [self populateGrids];}
    }
    if ([string isEqualToString:@"Manually" ]) {
        [self makeShips];
        
    }
    if ([string isEqualToString:@"Randomly" ]) {
        if (playerTurn == true) {
            [self setShipLocationsRandomlyForP1];
            [self clearGridText];
            playerTurn = false;
        }
        else {
            [self setShipLocationsRandomlyForP2];
            [self clearGridText];
            playerTurn = true;
            
        }
        [self startAlerts];
    }
}

-(void)startAlerts {
    
    // shows the collect alert for picking ship placements,
    // depending on who's turn it is and if the other player has set
    
    if (p1ShipsSet == true && p2ShipsSet == true) {
        NSString *s = @"";
        if (goesFirst == true) {
            s = @"Player 1 Goes First";
            playerTurn = true;
        }
        else {
            playerTurn = false;
            if (onePlayer == true) { s =  @"iPhone Goes First"; }
            else { s = @"Player 2 Goes First"; }
        }
        UIAlertView *start = [[UIAlertView alloc]
                              initWithTitle:@"Time to start the game"
                              message:s
                              delegate:self
                              cancelButtonTitle:@"It's go time!"
                              otherButtonTitles:nil];
        [start show];
    }
    else {
        if (playerTurn == false) {
            UIAlertView *p2turn = [[UIAlertView alloc]
                                   initWithTitle:@"It is time for Player 2 to place their ships"
                                   message:nil
                                   delegate:self
                                   cancelButtonTitle:nil
                                   otherButtonTitles:@"Set P2 Ships", nil];
            [p2turn show];
        }
        else {
            UIAlertView *p1turn = [[UIAlertView alloc]
                                   initWithTitle:@"It is time for Player 1 to place their ships"
                                   message:nil
                                   delegate:self
                                   cancelButtonTitle:nil
                                   otherButtonTitles:@"Set P1 Ships", nil];
            [p1turn show];
        }
    }
}

- (void)runARM {
    
    // automaically activates 10 guesses from each player's board
    
    typedef enum{E, H, M, S} battleEnum;
    for (int i = 0; i < 10; i++) {
        int randomTile = arc4random_uniform(100);
        while ( ![p1board[randomTile] isEqual: @(E)] ) {
            randomTile = arc4random_uniform(100);
        }
        p2guesses[randomTile] = @(M);
        p1board[randomTile] = @(M);
    }
    for (int i = 0; i < 10; i++) {
        int randomTile = arc4random_uniform(100);
        while ( ![p2board[randomTile] isEqual: @(E)] ) {
            randomTile = arc4random_uniform(100);
        }
        p1guesses[randomTile] = @(M);
        p2board[randomTile] = @(M);
    }
}

- (void)pickShipsForp1{
    UIAlertView *pickShipsAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Player 1, would you like to place your ships manually or randomly?"
                                   message:nil
                                   delegate:self
                                   cancelButtonTitle:nil
                                   otherButtonTitles:@"Manually", @"Randomly", nil];
    [pickShipsAlert show];
}

- (void)pickShipsForp2{
    UIAlertView *pickShipsAlert = [[UIAlertView alloc]
                                   initWithTitle:@"Player 2, would you like to place your ships manually or randomly?"
                                   message:nil
                                   delegate:self
                                   cancelButtonTitle:nil
                                   otherButtonTitles:@"Manually", @"Randomly", nil];
    [pickShipsAlert show];
}

- (void)pickplayer{
    
    // randomly select which player will go first
    // shows the correct alert and sets playerTurn and goesFirst
    
    int random = arc4random_uniform(2);
    if (onePlayer == true) {
        [self setShipLocationsRandomlyForP2];
    }
    if (random == 0) {
        playerTurn = true;
        goesFirst = true;
        UIAlertView *p1First = [[UIAlertView alloc]
                                initWithTitle:@"Player 1 Goes First"
                                message:nil
                                delegate:self
                                cancelButtonTitle:nil
                                otherButtonTitles:@"Set P1 Ships", nil];
        [p1First show];
    }
    else {
        goesFirst = false;
        if (onePlayer==true) {
            playerTurn = true;
            UIAlertView *p2First = [[UIAlertView alloc]
                                    initWithTitle:@"iPhone Goes First"
                                    message:nil
                                    delegate:self
                                    cancelButtonTitle:nil
                                    otherButtonTitles:@"Set P1 Ships", nil];
            
            [p2First show];
        }
        else {
            playerTurn = false;
            UIAlertView *p2First = [[UIAlertView alloc]
                                    initWithTitle:@"Player 2 Goes First"
                                    message:nil
                                    delegate:self
                                    cancelButtonTitle:nil
                                    otherButtonTitles:@"Set P2 Ships", nil];
            [p2First show];
        }
    }
}

- (void)setShipLocationsRandomlyForP1 {
    typedef enum{E, H, M, S} battleEnum;
    NSArray *layouts1 = @[
                          @30, @31, @34, @35, @36, @71, @72, @73, @47, @57, @67, @77, @13, @14, @15, @16, @17,
                          @84, @85, @71, @72, @73, @11, @21, @31, @24, @34, @44, @54, @48, @58, @68, @78, @88,
                          @44, @45, @51, @61, @71, @18, @28, @38, @11, @12, @13, @14, @58, @68, @78, @88, @98,
                          @25, @26, @55, @56, @57, @85, @86, @87, @11, @21, @31, @41, @52, @62, @72, @82, @92,
                          @21, @31, @52, @62, @72, @85, @86, @87, @27, @37, @47, @57, @14, @24, @34, @44, @54,
                          @80, @81, @83, @84, @85, @14, @15, @16, @32, @42, @52, @62, @37, @47, @57, @67, @77,
                          @24, @34, @55, @65, @75, @11, @21, @31, @81, @82, @83, @84, @18, @28, @38, @48, @58,
                          @77, @78, @71, @72, @73, @11, @12, @13, @24, @34, @44, @54, @8, @18, @28, @38, @48,
                          @40, @41, @1, @11, @21, @80, @81, @82, @23, @24, @25, @26, @63, @64, @65, @66, @67,
                          @6, @16, @66, @76, @86, @27, @37, @47, @10, @11, @12, @13, @41, @51, @61, @71, @81,
                          @41, @42, @53, @54, @55, @48, @58, @68, @14, @15, @16, @17, @81, @82, @83, @84, @85,
                          @18, @19, @48, @58, @68, @91, @92, @93, @34, @44, @54, @64, @11, @21, @31, @41, @51,
                          @0, @1, @97, @98, @99, @81, @82, @83, @4, @14, @24, @34, @28, @38, @48, @58, @68,
                          @21, @22, @61, @71, @81, @28, @38, @48, @14, @24, @34, @44, @55, @65, @75, @85, @95,
                          @11, @12, @15, @16, @17, @28, @38, @48, @41, @51, @61, @71, @34, @44, @54, @64, @74,
                          @11, @12, @23, @24, @25, @52, @53, @54, @65, @66, @67, @68, @80, @81, @82, @83, @84,
                          @0, @10, @79, @89, @99, @81, @82, @83, @31, @32, @33, @34, @63, @64, @65, @66, @67,
                          @88, @89, @61, @71, @81, @11, @12, @13, @24, @34, @44, @54, @18, @28, @38, @48, @58,
                          @24, @25, @51, @52, @53, @85, @86, @87, @10, @11, @12, @13, @18, @28, @38, @48, @58,
                          @50, @51, @42, @43, @44, @55, @56, @57, @81, @82, @83, @84, @11, @12, @13, @14, @15
                          ];
    int random = randomShips;
    int offSet = random*17;
    p1ship1[2] = @([layouts1[offSet + 0] integerValue]);
    p1ship1[3] = @([layouts1[offSet + 1] integerValue]);
    p1ship2[2] = @([layouts1[offSet + 2] integerValue]);
    p1ship2[3] = @([layouts1[offSet + 3] integerValue]);
    p1ship2[4] = @([layouts1[offSet + 4] integerValue]);
    p1ship3[2] = @([layouts1[offSet + 5] integerValue]);
    p1ship3[3] = @([layouts1[offSet + 6] integerValue]);
    p1ship3[4] = @([layouts1[offSet + 7] integerValue]);
    p1ship4[2] = @([layouts1[offSet + 8] integerValue]);
    p1ship4[3] = @([layouts1[offSet + 9] integerValue]);
    p1ship4[4] = @([layouts1[offSet + 10] integerValue]);
    p1ship4[5] = @([layouts1[offSet + 11] integerValue]);
    p1ship5[2] = @([layouts1[offSet + 12] integerValue]);
    p1ship5[3] = @([layouts1[offSet + 13] integerValue]);
    p1ship5[4] = @([layouts1[offSet + 14] integerValue]);
    p1ship5[5] = @([layouts1[offSet + 15] integerValue]);
    p1ship5[6] = @([layouts1[offSet + 16] integerValue]);
    
    for (int i = 0; i<17; i++) {
        p1board[[layouts1[offSet + i] integerValue]] = @(S);
    }
    p1ShipsSet = true;
}

- (void)setShipLocationsRandomlyForP2 {
    typedef enum{E, H, M, S} battleEnum;
    
    // chooses from a different set depending on whether P2 is a human or the iPhone
    
    if (onePlayer == true) {
        NSArray *layouts2 = @[
                              @11, @21, @24, @25, @26, @76, @77, @78, @33, @43, @53, @63, @81, @82, @83, @84, @85,
                              @13, @23, @54, @64, @74, @16, @17, @18, @51, @61, @71, @81, @48, @58, @68, @78, @88,
                              @45, @46, @62, @63, @64, @18, @28, @38, @11, @21, @31, @41, @84, @85, @86, @87, @88,
                              @18, @19, @93, @94, @95, @21, @22, @23, @42, @52, @62, @72, @26, @36, @46, @56, @66,
                              @57, @56, @65, @75, @85, @20, @21, @22, @25, @26, @27, @28, @43, @53, @63, @73, @83,
                              @34, @44, @28, @38, @48, @11, @12, @13, @71, @72, @73, @74, @85, @86, @87, @88, @89,
                              @40, @41, @77, @78, @79, @55, @56, @57, @81, @82, @83, @84, @13, @14, @15, @16, @17,
                              @21, @31, @52, @62, @72, @85, @86, @87, @15, @16, @17, @18, @24, @34, @44, @54, @64,
                              @45, @46, @76, @77, @78, @81, @82, @83, @11, @21, @31, @41, @14, @15, @16, @17, @18,
                              @18, @28, @63, @73, @83, @50, @51, @52, @11, @12, @13, @14, @85, @86, @87, @88, @89,
                              @44, @54, @72, @82, @92, @18, @28, @38, @68, @78, @88, @98, @11, @12, @13, @14, @15,
                              @21, @22, @51, @52, @53, @83, @84, @85, @18, @28, @38, @48, @26, @36, @46, @56, @66,
                              @70, @71, @83, @84, @85, @76, @77, @78, @2, @12, @22, @32, @44, @45, @46, @47, @48,
                              @26, @27, @43, @44, @45, @71, @81, @91, @74, @75, @76, @77, @01, @11, @21, @31, @41,
                              @55, @56, @64, @74, @84, @14, @24, @34, @21, @31, @41, @51, @28, @38, @48, @58, @68,
                              @91, @92, @16, @17, @18, @33, @34, @35, @61, @62, @63, @64, @57, @67, @77, @87, @97,
                              @11, @21, @82, @83, @84, @76, @77, @78, @14, @24, @34, @44, @8, @18, @28, @38, @48,
                              @72, @73, @84, @85, @86, @54, @55, @56, @2, @12, @22, @32, @42, @18, @28, @38, @48,
                              @60, @61, @74, @84, @94, @97, @98, @99, @16, @26, @36, @46, @2, @12, @22, @32, @42,
                              @0, @10, @51, @52, @53, @83, @84, @85, @22, @23, @24, @25, @48, @58, @68, @78, @88
                              ];
        int random = arc4random_uniform(20);
        int offSet = random*17;
        p2ship1[2] = @([layouts2[offSet + 0] integerValue]);
        p2ship1[3] = @([layouts2[offSet + 1] integerValue]);
        p2ship2[2] = @([layouts2[offSet + 2] integerValue]);
        p2ship2[3] = @([layouts2[offSet + 3] integerValue]);
        p2ship2[4] = @([layouts2[offSet + 4] integerValue]);
        p2ship3[2] = @([layouts2[offSet + 5] integerValue]);
        p2ship3[3] = @([layouts2[offSet + 6] integerValue]);
        p2ship3[4] = @([layouts2[offSet + 7] integerValue]);
        p2ship4[2] = @([layouts2[offSet + 8] integerValue]);
        p2ship4[3] = @([layouts2[offSet + 9] integerValue]);
        p2ship4[4] = @([layouts2[offSet + 10] integerValue]);
        p2ship4[5] = @([layouts2[offSet + 11] integerValue]);
        p2ship5[2] = @([layouts2[offSet + 12] integerValue]);
        p2ship5[3] = @([layouts2[offSet + 13] integerValue]);
        p2ship5[4] = @([layouts2[offSet + 14] integerValue]);
        p2ship5[5] = @([layouts2[offSet + 15] integerValue]);
        p2ship5[6] = @([layouts2[offSet + 16] integerValue]);
        for (int i = 0; i<17; i++) { p2board[[layouts2[offSet + i] integerValue]] = @(S); }
    }
    else {
        NSArray *layouts2 = @[
                              @30, @31, @34, @35, @36, @71, @72, @73, @47, @57, @67, @77, @13, @14, @15, @16, @17,
                              @84, @85, @71, @72, @73, @11, @21, @31, @24, @34, @44, @54, @48, @58, @68, @78, @88,
                              @44, @45, @51, @61, @71, @18, @28, @38, @11, @12, @13, @14, @58, @68, @78, @88, @98,
                              @25, @26, @55, @56, @57, @85, @86, @87, @11, @21, @31, @41, @52, @62, @72, @82, @92,
                              @21, @31, @52, @62, @72, @85, @86, @87, @27, @37, @47, @57, @14, @24, @34, @44, @54,
                              @80, @81, @83, @84, @85, @14, @15, @16, @32, @42, @52, @62, @37, @47, @57, @67, @77,
                              @24, @34, @55, @65, @75, @11, @21, @31, @81, @82, @83, @84, @18, @28, @38, @48, @58,
                              @77, @78, @71, @72, @73, @11, @12, @13, @24, @34, @44, @54, @8, @18, @28, @38, @48,
                              @40, @41, @1, @11, @21, @80, @81, @82, @23, @24, @25, @26, @63, @64, @65, @66, @67,
                              @6, @16, @66, @76, @86, @27, @37, @47, @10, @11, @12, @13, @41, @51, @61, @71, @81,
                              @41, @42, @53, @54, @55, @48, @58, @68, @14, @15, @16, @17, @81, @82, @83, @84, @85,
                              @18, @19, @48, @58, @68, @91, @92, @93, @34, @44, @54, @64, @11, @21, @31, @41, @51,
                              @0, @1, @97, @98, @99, @81, @82, @83, @4, @14, @24, @34, @28, @38, @48, @58, @68,
                              @21, @22, @61, @71, @81, @28, @38, @48, @14, @24, @34, @44, @55, @65, @75, @85, @95,
                              @11, @12, @15, @16, @17, @28, @38, @48, @41, @51, @61, @71, @34, @44, @54, @64, @74,
                              @11, @12, @23, @24, @25, @52, @53, @54, @65, @66, @67, @68, @80, @81, @82, @83, @84,
                              @0, @10, @79, @89, @99, @81, @82, @83, @31, @32, @33, @34, @63, @64, @65, @66, @67,
                              @88, @89, @61, @71, @81, @11, @12, @13, @24, @34, @44, @54, @18, @28, @38, @48, @58,
                              @24, @25, @51, @52, @53, @85, @86, @87, @10, @11, @12, @13, @18, @28, @38, @48, @58,
                              @50, @51, @42, @43, @44, @55, @56, @57, @81, @82, @83, @84, @11, @12, @13, @14, @15
                              ];
        int random = arc4random_uniform(20);
        while (random == randomShips) {
            random = arc4random_uniform(20);
        }
        int offSet = random*17;
        p2ship1[2] = @([layouts2[offSet + 0] integerValue]);
        p2ship1[3] = @([layouts2[offSet + 1] integerValue]);
        p2ship2[2] = @([layouts2[offSet + 2] integerValue]);
        p2ship2[3] = @([layouts2[offSet + 3] integerValue]);
        p2ship2[4] = @([layouts2[offSet + 4] integerValue]);
        p2ship3[2] = @([layouts2[offSet + 5] integerValue]);
        p2ship3[3] = @([layouts2[offSet + 6] integerValue]);
        p2ship3[4] = @([layouts2[offSet + 7] integerValue]);
        p2ship4[2] = @([layouts2[offSet + 8] integerValue]);
        p2ship4[3] = @([layouts2[offSet + 9] integerValue]);
        p2ship4[4] = @([layouts2[offSet + 10] integerValue]);
        p2ship4[5] = @([layouts2[offSet + 11] integerValue]);
        p2ship5[2] = @([layouts2[offSet + 12] integerValue]);
        p2ship5[3] = @([layouts2[offSet + 13] integerValue]);
        p2ship5[4] = @([layouts2[offSet + 14] integerValue]);
        p2ship5[5] = @([layouts2[offSet + 15] integerValue]);
        p2ship5[6] = @([layouts2[offSet + 16] integerValue]);
        for (int i = 0; i<17; i++) { p2board[[layouts2[offSet + i] integerValue]] = @(S); }
    }
    p2ShipsSet = true;
}

- (void)hideTopGrid {
    for( int i = 0; i < 100; i++ ) { [[topGrid objectAtIndex: i] setHidden:true]; }
}

- (void)showTopGrid {
    for( int i = 0; i < 100; i++ ) { [[topGrid objectAtIndex: i] setHidden:false]; }
}

- (void)clearGridText {
    
    // blanks out top and bottom grids, makes them black, and blanks out labels
    
    for( int i = 0; i < 100; i++ ) {
        [[topGrid objectAtIndex: i] setTitle: @"" forState: UIControlStateNormal];
        [[topGrid objectAtIndex: i] setBackgroundColor:[UIColor blackColor]];
        [[bottomGrid objectAtIndex: i] setText: @"" ];
        [[bottomGrid objectAtIndex: i] setBackgroundColor:[UIColor blackColor]];
    }
    hitTitle.text = @"";
    guessesTitle.text = @"";
    boardTitle.text = @"";
    attackButton.hidden = true;
}

- (void)resetBoardsandGuesses {
    
    // resest boards, guesses, and ships locations for each player
    
    typedef enum{E, H, M, S} battleEnum;
    for( int i = 0; i < 100; i++ ) {
        p1guesses[i] = @(E);
        p2guesses[i] = @(E);
        p1board[i] = @(E);
        p2board[i] = @(E);
    }
    p1ship1[2] = @(100);
    p1ship1[3] = @(101);
    p1ship2[2] = @(102);
    p1ship2[3] = @(103);
    p1ship2[4] = @(104);
    p1ship3[2] = @(105);
    p1ship3[3] = @(106);
    p1ship3[4] = @(107);
    p1ship4[2] = @(108);
    p1ship4[3] = @(109);
    p1ship4[4] = @(110);
    p1ship4[5] = @(111);
    p1ship5[2] = @(112);
    p1ship5[3] = @(113);
    p1ship5[4] = @(114);
    p1ship5[5] = @(115);
    p1ship5[6] = @(116);
    
    p2ship1[2] = @(100);
    p2ship1[3] = @(101);
    p2ship2[2] = @(102);
    p2ship2[3] = @(103);
    p2ship2[4] = @(104);
    p2ship3[2] = @(105);
    p2ship3[3] = @(106);
    p2ship3[4] = @(107);
    p2ship4[2] = @(108);
    p2ship4[3] = @(109);
    p2ship4[4] = @(110);
    p2ship4[5] = @(111);
    p2ship5[2] = @(112);
    p2ship5[3] = @(113);
    p2ship5[4] = @(114);
    p2ship5[5] = @(115);
    p2ship5[6] = @(116);
}

- (void)populateGrids {
    
    // depending on who's turn it is,
    // the grids populate with the guesses and board of that player
    // the correct labels are also shown
    
    typedef enum{E, H, M, S} battleEnum;
    if (playerTurn == true) {
        for( int i = 0; i < 100; i++ ) {
            if ([p1guesses[i] isEqual: @(E)]){
                [[topGrid objectAtIndex: i] setTitle: @"" forState: UIControlStateNormal];
                [[topGrid objectAtIndex: i] setBackgroundColor:[UIColor blueColor]];
            }
            else if ([p1guesses[i] isEqual: @(H)]){
                [[topGrid objectAtIndex: i] setTitle: @"X" forState: UIControlStateNormal];
                [[topGrid objectAtIndex: i] setBackgroundColor:[UIColor redColor]];
            }
            else {
                [[topGrid objectAtIndex: i] setTitle: @"O" forState: UIControlStateNormal];
                [[topGrid objectAtIndex: i] setBackgroundColor:[UIColor whiteColor]];
            }
            if ([p1board[i] isEqual: @(E)]){
                [[bottomGrid objectAtIndex: i] setText: @""];
                [[bottomGrid objectAtIndex: i] setBackgroundColor:[UIColor blueColor]];
            }
            else if ([p1board[i] isEqual: @(H)]){
                [[bottomGrid objectAtIndex: i] setText: @"X"];
                [[bottomGrid objectAtIndex: i] setBackgroundColor:[UIColor redColor]];
            }
            else if ([p1board[i] isEqual: @(M)]){
                [[bottomGrid objectAtIndex: i] setText: @"O"];
                [[bottomGrid objectAtIndex: i] setBackgroundColor:[UIColor whiteColor]];
            }
            else {
                [[bottomGrid objectAtIndex: i] setText: @""];
                [[bottomGrid objectAtIndex: i] setBackgroundColor:[UIColor grayColor]];
            }
        }
        if (p1shipHitCounter == 1) { hitTitle.text = [NSString stringWithFormat:@"%i Ship Sunk", p1shipHitCounter]; }
        else {hitTitle.text = [NSString stringWithFormat:@"%i Ships Sunk", p1shipHitCounter]; }
        guessesTitle.text = @"Player 1's Guesses";
        boardTitle.text = @"Player 1's Board";
    }
    else {
        for( int i = 0; i < 100; i++ ) {
            if ([p2guesses[i] isEqual: @(E)]){
                [[topGrid objectAtIndex: i] setTitle: @"" forState: UIControlStateNormal];
                [[topGrid objectAtIndex: i] setBackgroundColor:[UIColor blueColor]];
            }
            else if ([p2guesses[i] isEqual: @(H)]){
                [[topGrid objectAtIndex: i] setTitle: @"X" forState: UIControlStateNormal];
                [[topGrid objectAtIndex: i] setBackgroundColor:[UIColor redColor]];
            }
            else {
                [[topGrid objectAtIndex: i] setTitle: @"O" forState: UIControlStateNormal];
                [[topGrid objectAtIndex: i] setBackgroundColor:[UIColor whiteColor]];
            }
            if ([p2board[i] isEqual: @(E)]){
                [[bottomGrid objectAtIndex: i] setText: @""];
                [[bottomGrid objectAtIndex: i] setBackgroundColor:[UIColor blueColor]];
            }
            else if ([p2board[i] isEqual: @(H)]){
                [[bottomGrid objectAtIndex: i] setText: @"X"];
                [[bottomGrid objectAtIndex: i] setBackgroundColor:[UIColor redColor]];
            }
            else if ([p2board[i] isEqual: @(M)]){
                [[bottomGrid objectAtIndex: i] setText: @"O"];
                [[bottomGrid objectAtIndex: i] setBackgroundColor:[UIColor whiteColor]];
            }
            else {
                [[bottomGrid objectAtIndex: i] setText: @""];
                [[bottomGrid objectAtIndex: i] setBackgroundColor:[UIColor grayColor]];
            }
        }
        if (p2shipHitCounter == 1) { hitTitle.text = [NSString stringWithFormat:@"%i Ship Sunk", p2shipHitCounter]; }
        else {hitTitle.text = [NSString stringWithFormat:@"%i Ships Sunk", p2shipHitCounter]; }
        guessesTitle.text = @"Player 2's Guesses";
        boardTitle.text = @"Player 2's Board";
    }
    
}

- (void)buttonClicked:(UIButton*)button {
    
    // button for top grid, which is guesses
    // only works if this is not the end of the game
    // tiles turn green to highlight the pressed square
    // when a tile is pressed, the attack button appears
    
    
    typedef enum{E, H, M, S} battleEnum;
    int currentTag = (int)[button tag];
    if (endGame == false) {
        attackButton.hidden = false;
        if (playerTurn == true) {
            if ([p1guesses[currentTag]  isEqual: @(E)]) {
                if (attackReady == false) {
                    attackReady = true;
                    attackTile = currentTag;
                    [[topGrid objectAtIndex: currentTag] setBackgroundColor:[UIColor greenColor]];
                }
                else {
                    [[topGrid objectAtIndex: attackTile] setBackgroundColor:[UIColor blueColor]];
                    attackTile = currentTag;
                    [[topGrid objectAtIndex: currentTag] setBackgroundColor:[UIColor greenColor]];
                }
            }
            else { [notEmptyAlert show]; }
        }
        else {
            if ([p2guesses[currentTag]  isEqual: @(E)]) {
                if (attackReady == false) {
                    attackReady = true;
                    attackTile = currentTag;
                    [[topGrid objectAtIndex: currentTag] setBackgroundColor:[UIColor greenColor]];
                    
                }
                else {
                    [[topGrid objectAtIndex: attackTile] setBackgroundColor:[UIColor blueColor]];
                    attackTile = currentTag;
                    [[topGrid objectAtIndex: currentTag] setBackgroundColor:[UIColor greenColor]];
                }
            }
            else { [notEmptyAlert show]; }
        }
    }
}

- (void)newGameButtonClicked:(UIButton*)button {
    UIAlertView *newGameAlert = [[UIAlertView alloc]
                                 initWithTitle:@"Would you like to start a new game?"
                                 message:nil
                                 delegate:self
                                 cancelButtonTitle:@"No"
                                 otherButtonTitles:@"Yes", nil];
    [newGameAlert show];
}

- (void)attackButtonClicked:(UIButton*)button {
    
    // if the game is over, do nothing
    // if no tile has been picked, alert user
    // else attack the proper tile
    
    if (endGame == false) {
        if (attackReady == false) {
            UIAlertView *attackAlert = [[UIAlertView alloc]
                                        initWithTitle:@"First, pick a tile to attack"
                                        message:nil
                                        delegate:self
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
            [attackAlert show];
        }
        else {
            attackReady = false;
            [self playTile:attackTile];
            attackButton.hidden = true;
        }
    }
}

- (void)allShipButtonClicked:(UIButton*)button {
    
    // user tells the app that they have finished setting their ships locations
    
    allShipsSet.hidden = true;
    [self shipsAreSet];
}

- (void)playTile:(int) tile {
    
    // first method called when a tile is played
    // if it is a miss, set the board and guesses, and alert the user
    // if it is a hit, set the board and guesses, check for a win
    // if it is not a win, call the hit method
    
    typedef enum{E, H, M, S} battleEnum;
    if (playerTurn == true) {
        if ([p2board[tile]  isEqual: @(E)]) {
            p2board[tile] = @(M);
            p1guesses[tile] = @(M);
            NSString *s = [NSString stringWithFormat:@"%@ is a miss", [names objectAtIndex:tile]];
            UIAlertView *miss = [[UIAlertView alloc]
                                 initWithTitle:s
                                 message:nil
                                 delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"Affirmitive", nil];
            [miss show];
            [self populateGrids];
        }
        else {
            p2board[tile] = @(H);
            p1guesses[tile] = @(H);
            p1hitCounter++;
            if (p1hitCounter == 17) {
                p1shipHitCounter++;
                [self win];
            }
            else { [self hit:(tile)]; }
        }
    }
    else {
        if ([p1board[tile]  isEqual: @(E)]) {
            p1board[tile] = @(M);
            p2guesses[tile] = @(M);
            if (onePlayer == false) {
                NSString *s = [NSString stringWithFormat:@"%@ is a miss", [names objectAtIndex:tile]];
                UIAlertView *miss = [[UIAlertView alloc]
                                     initWithTitle:s
                                     message:nil
                                     delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@"Affirmitive", nil];
                [miss show];
                [self populateGrids];
            }
            else {
                NSString *s = [NSString stringWithFormat:@"%@ is a miss from iPhone", [names objectAtIndex:tile]];
                UIAlertView *miss = [[UIAlertView alloc]
                                     initWithTitle:s
                                     message:nil
                                     delegate:self
                                     cancelButtonTitle:nil
                                     otherButtonTitles:@"Roger", nil];
                [miss show];
                playerTurn = true;
                [self populateGrids];
            }
        }
        else {
            p1board[tile] = @(H);
            p2guesses[tile] = @(H);
            p2hitCounter++;
            if (p2hitCounter == 17) {
                p2shipHitCounter++;
                [self win];
            }
            else { [self hit:(tile)]; }
        }
    }
}

- (void)hit:(int) tile {
    
    // checks for which ship was hit
    // if this hit sinks a ship, call sunkShip method and alert user
    // else still alert user
    // if the iPhone sinks a ship, swtiches to random play
    // else, it switches to attack mode
    
    
    NSString *s = @"";
    if (playerTurn == true) {
        for (int i=0; i<2; i++){
            if ([p2ship1[i+2] isEqual: @(tile)]) {
                p2ship1Counter--;
                if (p2ship1Counter == 0) {
                    [self sunkShip];
                    if (onePlayer == false) { s = [NSString stringWithFormat:@"You sunk Player 2's %@!!", [p2ship1 objectAtIndex:1]]; }
                    else { s = [NSString stringWithFormat:@"You sunk iPhone's %@!!",[p2ship1 objectAtIndex:1]]; }
                }
                else { s = [NSString stringWithFormat:@"%@ is a hit. %@", [names objectAtIndex:tile], [p2ship1 objectAtIndex:1]]; }
            }
        }
        for (int i=0; i<3; i++){
            if ([p2ship2[i+2] isEqual: @(tile)]) {
                p2ship2Counter--;
                if (p2ship2Counter == 0) {
                    [self sunkShip];
                    if (onePlayer == false) { s = [NSString stringWithFormat:@"You sunk Player 2's %@!!", [p2ship2 objectAtIndex:1]]; }
                    else { s = [NSString stringWithFormat:@"You sunk iPhone's %@!!",[p2ship2 objectAtIndex:1]]; }
                }
                else { s = [NSString stringWithFormat:@"%@ is a hit. %@", [names objectAtIndex:tile], [p2ship2 objectAtIndex:1]]; }
            }
        }
        for (int i=0; i<3; i++){
            if ([p2ship3[i+2] isEqual: @(tile)]) {
                p2ship3Counter--;
                if (p2ship3Counter == 0) {
                    [self sunkShip];
                    if (onePlayer == false) { s = [NSString stringWithFormat:@"You sunk Player 2's %@!!", [p2ship3 objectAtIndex:1]]; }
                    else { s = [NSString stringWithFormat:@"You sunk iPhone's %@!!",[p2ship3 objectAtIndex:1]]; }
                }
                else { s = [NSString stringWithFormat:@"%@ is a hit. %@", [names objectAtIndex:tile], [p2ship3 objectAtIndex:1]]; }
            }
        }
        for (int i=0; i<4; i++){
            if ([p2ship4[i+2] isEqual: @(tile)]) {
                p2ship4Counter--;
                if (p2ship4Counter == 0) {
                    [self sunkShip];
                    if (onePlayer == false) { s = [NSString stringWithFormat:@"You sunk Player 2's %@!!", [p2ship4 objectAtIndex:1]]; }
                    else { s = [NSString stringWithFormat:@"You sunk iPhone's %@!!",[p2ship4 objectAtIndex:1]]; }
                }
                else { s = [NSString stringWithFormat:@"%@ is a hit. %@", [names objectAtIndex:tile], [p2ship4 objectAtIndex:1]]; }
            }
        }
        for (int i=0; i<5; i++){
            if ([p2ship5[i+2] isEqual: @(tile)]) {
                p2ship5Counter--;
                if (p2ship5Counter == 0) {
                    [self sunkShip];
                    if (onePlayer == false) { s = [NSString stringWithFormat:@"You sunk Player 2's %@!!", [p2ship5 objectAtIndex:1]]; }
                    else { s = [NSString stringWithFormat:@"You sunk iPhone's %@!!",[p2ship5 objectAtIndex:1]]; }
                }
                else { s = [NSString stringWithFormat:@"%@ is a hit. %@", [names objectAtIndex:tile], [p2ship5 objectAtIndex:1]]; }
            }
        }
    }
    else {
        for (int i=0; i<2; i++){
            if ([p1ship1[i+2] isEqual: @(tile)]) {
                p1ship1Counter--;
                if (p1ship1Counter == 0) {
                    [self sunkShip];
                    if (onePlayer == false) { s = [NSString stringWithFormat:@"You sunk Player 1's %@!!", [p1ship1 objectAtIndex:1]]; }
                    else {
                        s = [NSString stringWithFormat:@"iPhone sunk your %@!!", [p1ship1 objectAtIndex:1]];
                        randomPlay = true;
                    }
                }
                else {
                    if (onePlayer == false) { s = [NSString stringWithFormat:@"%@ is a hit. %@", [names objectAtIndex:tile], [p1ship1 objectAtIndex:1]]; }
                    else {
                        s = [NSString stringWithFormat:@"iPhone hit your %@", [p1ship1 objectAtIndex:1]];
                        [self iphoneAttackMode:(tile)];
                        hitShip = 1;
                    }
                }
            }
        }
        for (int i=0; i<3; i++){
            if ([p1ship2[i+2] isEqual: @(tile)]) {
                p1ship2Counter--;
                if (p1ship2Counter == 0) {
                    [self sunkShip];
                    if (onePlayer == false) { s = [NSString stringWithFormat:@"You sunk Player 1's %@!!", [p1ship2 objectAtIndex:1]]; }
                    else {
                        s = [NSString stringWithFormat:@"iPhone sunk your %@!!", [p1ship2 objectAtIndex:1]];
                        randomPlay = true;
                    }
                }
                else {
                    if (onePlayer == false) { s = [NSString stringWithFormat:@"%@ is a hit. %@", [names objectAtIndex:tile], [p1ship2 objectAtIndex:1]]; }
                    else {
                        s = [NSString stringWithFormat:@"iPhone hit your %@", [p1ship2 objectAtIndex:1]];
                        [self iphoneAttackMode:(tile)];
                        hitShip = 2;
                    }
                }
            }
        }
        for (int i=0; i<3; i++){
            if ([p1ship3[i+2] isEqual: @(tile)]) {
                p1ship3Counter--;
                if (p1ship3Counter == 0) {
                    [self sunkShip];
                    if (onePlayer == false) { s = [NSString stringWithFormat:@"You sunk Player 1's %@!!", [p1ship3 objectAtIndex:1]]; }
                    else {
                        s = [NSString stringWithFormat:@"iPhone sunk your %@!!", [p1ship3 objectAtIndex:1]];
                        randomPlay = true;
                    }
                }
                else {
                    if (onePlayer == false) { s = [NSString stringWithFormat:@"%@ is a hit. %@", [names objectAtIndex:tile], [p1ship3 objectAtIndex:1]]; }
                    else {
                        s = [NSString stringWithFormat:@"iPhone hit your %@", [p1ship3 objectAtIndex:1]];
                        [self iphoneAttackMode:(tile)];
                        hitShip = 3;
                    }
                }
            }
        }
        for (int i=0; i<4; i++){
            if ([p1ship4[i+2] isEqual: @(tile)]) {
                p1ship4Counter--;
                if (p1ship4Counter == 0) {
                    [self sunkShip];
                    if (onePlayer == false) { s = [NSString stringWithFormat:@"You sunk Player 1's %@!!", [p1ship4 objectAtIndex:1]]; }
                    else {
                        s = [NSString stringWithFormat:@"iPhone sunk your %@!!", [p1ship4 objectAtIndex:1]];
                        randomPlay = true;
                    }
                }
                else {
                    if (onePlayer == false) { s = [NSString stringWithFormat:@"%@ is a hit. %@", [names objectAtIndex:tile], [p1ship4 objectAtIndex:1]]; }
                    else {
                        s = [NSString stringWithFormat:@"iPhone hit your %@", [p1ship4 objectAtIndex:1]];
                        [self iphoneAttackMode:(tile)];
                        hitShip = 4;
                    }
                }
            }
        }
        for (int i=0; i<5; i++){
            if ([p1ship5[i+2] isEqual: @(tile)]) {
                p1ship5Counter--;
                if (p1ship5Counter == 0) {
                    [self sunkShip];
                    if (onePlayer == false) { s = [NSString stringWithFormat:@"You sunk Player 1's %@!!", [p1ship5 objectAtIndex:1]]; }
                    else {
                        s = [NSString stringWithFormat:@"iPhone sunk your %@!!", [p1ship5 objectAtIndex:1]];
                        randomPlay = true;
                    }
                }
                else {
                    if (onePlayer == false) { s = [NSString stringWithFormat:@"%@ is a hit. %@", [names objectAtIndex:tile], [p1ship5 objectAtIndex:1]]; }
                    else {
                        s = [NSString stringWithFormat:@"iPhone hit your %@", [p1ship5 objectAtIndex:1]];
                        [self iphoneAttackMode:(tile)];
                        hitShip = 5;
                    }
                }
            }
        }
    }
    
    if (onePlayer == false || playerTurn == true) {
        UIAlertView *hitAlert = [[UIAlertView alloc]
                                 initWithTitle:s
                                 message:nil
                                 delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"Affirmitive", nil];
        [hitAlert show];
    }
    else {
        UIAlertView *hitAlert = [[UIAlertView alloc]
                                 initWithTitle:s
                                 message:nil
                                 delegate:self
                                 cancelButtonTitle:nil
                                 otherButtonTitles:@"Roger", nil];
        [hitAlert show];
    }
    if (onePlayer == true && playerTurn == false) { playerTurn = true; }
    [self populateGrids];
}

- (void)sunkShip {
    
    // plays explosion SFX, increments hitCounters
    
    [sinkSound play];
    if (playerTurn == true) { p1shipHitCounter++; }
    else { p2shipHitCounter++; }
}

- (void)switchPlayer {
    
    // clears gird (turns black) and alerts user to hand the phone to the other human player
    
    [self clearGridText];
    NSString *s = @"";
    if (playerTurn == false) {
        playerTurn = true;
        s = @"It is now Player 1's turn";
    }
    else {
        playerTurn = false;
        s = @"It is now Player 2's turn";
    }
    UIAlertView *switchAlert = [[UIAlertView alloc]
                                initWithTitle:s
                                message:nil
                                delegate:self
                                cancelButtonTitle:nil
                                otherButtonTitles:@"Let's Do This!", nil];
    [switchAlert show];
}

- (void)win {
    
    // sets endGame to true, alerts user and plays FX
    
    endGame = true;
    NSString *s = @"";
    if (playerTurn == true) {
        s = @"Player 1 Wins!!!";
        [self populateGrids];
        [winSound play];
    }
    else if (playerTurn == false) {
        if (onePlayer == false) {
            s = @"Player 2 Wins!!!";
            [self populateGrids];
            [winSound play];}
        else {
            s = @"iPhone Wins :(";
            playerTurn = true;
            [self populateGrids];
            [loseSound play];
        }
    }
    UIAlertView *winAlert = [[UIAlertView alloc]
                             initWithTitle:s
                             message:@"Play Again?"
                             delegate:self
                             cancelButtonTitle:@"No"
                             otherButtonTitles:@"Yes", nil];
    [winAlert show];
}

- (void)iphoneAttackMode:(int) tile {
    
    // sets attack mode and sets the origin of this original hit
    
    if (randomPlay == true) { originHit = tile; }
    randomPlay = false;
}

- (void)iPhonePlay {
    
    // AI for iphone
    // if the play is random, sort of randomly pick a tile
    // it is a bit more complicated
    //  1/6 of the time the tile selected is truly random
    // the other 5/6 of the time, it picks from a multiple of 3 plus an offset
    // offset is between 0 and 2 that is pick at the start of the game
    // this I found is  good way to find ships stragicially and avoids clumps
    // if play is not random, then stragically try to sink the hit ship
    // this is done by randomly picking an avilible next move
    // if this is a hit, move in that direction until a tile no longer exist or is a miss
    // if that occus and reverse direction
    
    typedef enum{E, H, M, S} battleEnum;
    playerTurn = false;
    if (randomPlay == true) {
        hitDirection = 0;
        int randomTile = ((arc4random_uniform(33) * 3) + aiOffset);
        while ([p1board[randomTile] isEqual: @(M)] || [p1board[randomTile] isEqual: @(H)] ) {
            int howRandom = arc4random_uniform(7);
            if (howRandom == 0) {randomTile = arc4random_uniform(100); }
            else { randomTile = ((arc4random_uniform(33) * 3) + aiOffset); }
        }
        [self playTile:randomTile];
    }
    else {
        if (hitDirection == 0) {
            int tempDirection = [self randomDirection];
            while ( [self tileExists:originHit direction:tempDirection] == false ) {
                tempDirection = [self randomDirection];
            }
            int pickedTile = originHit+tempDirection;
            if ( [p1board[ pickedTile ] isEqual: @(S)] ) {
                currentHit = pickedTile;
                hitDirection = tempDirection;
            }
            [self playTile: pickedTile ];
        }
        else {
            if ( [self tileExists:currentHit direction:hitDirection ] == true ) {
                int pickedTile = currentHit + hitDirection;
                
                if ( [p1board[ pickedTile ] isEqual: @(S)] ) { currentHit = pickedTile; }
                else {
                    currentHit = originHit;
                    hitDirection = hitDirection * -1;
                }
                [self playTile: pickedTile];
            }
            else {
                currentHit = originHit;
                hitDirection = hitDirection * -1;
                int pickedTile = currentHit + hitDirection;
                [self playTile: pickedTile];
                currentHit = pickedTile;
            }
        }
    }
}

- (int)randomDirection {
    int randomVal = arc4random_uniform(4);
    int tempDirection = 0;
    if (randomVal == 0) { tempDirection = -10; }
    else if (randomVal == 1) { tempDirection = 10; }
    else if (randomVal == 2) { tempDirection = 1; }
    else { tempDirection = -1; }
    return tempDirection;
}

- (BOOL)tileExists:(int) currentPos
         direction: (int) currentDirection {
    
    // checks if a tile is off the board and if not, that it is empty or contains a ship
    
    typedef enum{E, H, M, S} battleEnum;
    BOOL eval = false;
    int x = currentPos + currentDirection;
    int y = currentPos;
    if ( (x > -1) && (x < 100) && ( ([p1board[x] isEqual: @(E)]) || ([p1board[x] isEqual: @(S)]) ) ) {
        if ( (currentDirection == 10) || (currentDirection == -10) ) { eval = [self sameShip:x]; }
        else {
            if ( (x > (y - (y % 10)) - 1) && (x < (y - (y % 10)) + 10) ) { eval = [self sameShip:x]; }
            else { eval = false; }
        }
    }
    else { eval = false; }
    return eval;
}

- (BOOL)sameShip:(int) x {
    
    // checks if a hit will be on the same ship
    
    typedef enum{E, H, M, S} battleEnum;
    int localShip = 0;
    if ( [p1board[x] isEqual: @(E)] ) { return true; }
    else {
        for (int i=0; i<2; i++){ if ([p1ship1[i+2] isEqual: @(x)]) { localShip = 1; } }
        for (int i=0; i<3; i++){ if ([p1ship2[i+2] isEqual: @(x)]) { localShip = 2; } }
        for (int i=0; i<3; i++){ if ([p1ship3[i+2] isEqual: @(x)]) { localShip = 3; } }
        for (int i=0; i<4; i++){ if ([p1ship4[i+2] isEqual: @(x)]) { localShip = 4; } }
        for (int i=0; i<5; i++){ if ([p1ship5[i+2] isEqual: @(x)]) { localShip = 5; } }
        if ( hitShip == localShip) { return true; }
        else { return false; }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // if a ships is touched, set a global variable 'selectedShip' to ship number
    // center ship under touch event
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    if (CGRectContainsPoint([ship1 frame], touchLocation)) {
        selectedShip = 1;
        ship1.center = touchLocation;
    }
    else if (CGRectContainsPoint([ship2 frame], touchLocation)) {
        selectedShip = 2;
        ship2.center = touchLocation;
    }
    else if (CGRectContainsPoint([ship3 frame], touchLocation)) {
        selectedShip = 3;
        ship3.center = touchLocation;
    }
    else if (CGRectContainsPoint([ship4 frame], touchLocation)) {
        selectedShip = 4;
        ship4.center = touchLocation;
    }
    else if (CGRectContainsPoint([ship5 frame], touchLocation)) {
        selectedShip = 5;
        ship5.center = touchLocation;
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // ship moves under finger
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    switch (selectedShip) {
        case 1:
            ship1.center = touchLocation; break;
        case 2:
            ship2.center = touchLocation; break;
        case 3:
            ship3.center = touchLocation; break;
        case 4:
            ship4.center = touchLocation; break;
        case 5:
            ship5.center = touchLocation; break;
        default:
            break;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // if the ship is dropped in the rotate square, rotate and set inner orientation value
    // loops through all of the tiles in the bottom grid
    // if the top left corner is within a tile, reset stip location to lock to grid
    // set ships inner location values apropriately
    // it will not lock if part of the ship is off of the board
    // if the ship does not lock in, reset it's location inner values
    // finally, if all the ships are locked in place, show the 'allShipsSet' button
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    CGPoint point;
    point.x = 100;
    point.y = 100;
    if (CGRectContainsPoint([dropRotateBox frame], touchLocation)) {
        switch (selectedShip) {
            case 1:
                if ([ship1.text isEqualToString:@"v"]) {
                    [ship1 setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
                    ship1.text = @"h";
                }
                else {
                    [ship1 setTransform:CGAffineTransformMakeRotation(-M_PI / 1)];
                    ship1.text = @"v";
                }
                break;
            case 2:
                if ([ship2.text isEqualToString:@"v"]) {
                    [ship2 setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
                    ship2.text = @"h";
                }
                else {
                    [ship2 setTransform:CGAffineTransformMakeRotation(-M_PI / 1)];
                    ship2.text = @"v";
                }
                break;
            case 3:
                if ([ship3.text isEqualToString:@"v"]) {
                    [ship3 setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
                    ship3.text = @"h";
                }
                else {
                    [ship3 setTransform:CGAffineTransformMakeRotation(-M_PI / 1)];
                    ship3.text = @"v";
                }
                break;
            case 4:
                if ([ship4.text isEqualToString:@"v"]) {
                    [ship4 setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
                    ship4.text = @"h";
                }
                else {
                    [ship4 setTransform:CGAffineTransformMakeRotation(-M_PI / 1)];
                    ship4.text = @"v";
                }
                break;
            case 5:
                if ([ship5.text isEqualToString:@"v"]) {
                    [ship5 setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
                    ship5.text = @"h";
                }
                else {
                    [ship5 setTransform:CGAffineTransformMakeRotation(-M_PI / 1)];
                    ship5.text = @"v";
                }
                break;
            default:
                break;
        }
    }
    int x = 30;
    int y = 360;
    bool triggered = false;
    for( int i = 0; i < 100; i++ ) {
        if (i%10 == 0 && i != 0){
            x = 30;
            y += 20;
        }
        switch (selectedShip) {
            case 1:
                if ( ([ship1.text isEqualToString:@"v"] && (i<90)) || ([ship1.text isEqualToString:@"h"] && ((i%10) < 9)) ) {
                    if ( (x < (ship1.frame.origin.x + 10)) && ((x+20) > (ship1.frame.origin.x + 10)) &&
                        (y < (ship1.frame.origin.y + 10)) && ((y+20) > (ship1.frame.origin.y + 10)) ) {
                        triggered = true;
                        [ship1 setFrame:CGRectMake(x, y, ship1.frame.size.width, ship1.frame.size.height)];
                        for( int j = 0; j < 2; j++ ) {
                            if ([ship1.text isEqualToString:@"v"]) {
                                if (playerTurn == true) { p1ship1[j+2] = @(i+(j*10)); }
                                else { p2ship1[j+2] = @((i+(j*10))); }
                            }
                            else {
                                if (playerTurn == true) { p1ship1[j+2] = @(i+j); }
                                else { p2ship1[j+2] = @(i+j); }
                            }
                        }
                        if (playerTurn == true) { [self shipConflictCheck:p1ship1]; }
                        else { [self shipConflictCheck:p2ship1]; }
                    }
                }
                break;
            case 2:
                if ( ([ship2.text isEqualToString:@"v"] && (i<80)) || ([ship2.text isEqualToString:@"h"] && ((i%10) < 8)) ) {
                    if ( (x < (ship2.frame.origin.x + 10)) && ((x+20) > (ship2.frame.origin.x + 10)) &&
                        (y < (ship2.frame.origin.y + 10)) && ((y+20) > (ship2.frame.origin.y + 10)) ) {
                        triggered = true;
                        [ship2 setFrame:CGRectMake(x, y, ship2.frame.size.width, ship2.frame.size.height)];
                        for( int j = 0; j < 3; j++ ) {
                            if ([ship2.text isEqualToString:@"v"]) {
                                if (playerTurn == true) { p1ship2[j+2] = @(i+(j*10)); }
                                else { p2ship2[j+2] = @((i+(j*10))); }
                            }
                            else {
                                if (playerTurn == true) { p1ship2[j+2] = @(i+j); }
                                else { p2ship2[j+2] = @(i+j); }
                            }
                        }
                        if (playerTurn == true) { [self shipConflictCheck:p1ship2];}
                        else { [self shipConflictCheck:p2ship2]; }
                    }
                }
                break;
            case 3:
                if ( ([ship3.text isEqualToString:@"v"] && (i<80)) || ([ship3.text isEqualToString:@"h"] && ((i%10) < 8)) ) {
                    if ( (x < (ship3.frame.origin.x + 10)) && ((x+20) > (ship3.frame.origin.x + 10)) &&
                        (y < (ship3.frame.origin.y + 10)) && ((y+20) > (ship3.frame.origin.y + 10)) ) {
                        triggered = true;
                        [ship3 setFrame:CGRectMake(x, y, ship3.frame.size.width, ship3.frame.size.height)];
                        for( int j = 0; j < 3; j++ ) {
                            if ([ship3.text isEqualToString:@"v"]) {
                                if (playerTurn == true) { p1ship3[j+2] = @(i+(j*10)); }
                                else { p2ship3[j+2] = @((i+(j*10))); }
                            }
                            else {
                                if (playerTurn == true) { p1ship3[j+2] = @(i+j); }
                                else { p2ship3[j+2] = @(i+j); }
                            }
                        }
                        if (playerTurn == true) { [self shipConflictCheck:p1ship3];}
                        else { [self shipConflictCheck:p2ship3]; }
                    }
                }
                break;
            case 4:
                if ( ([ship4.text isEqualToString:@"v"] && (i<70)) || ([ship4.text isEqualToString:@"h"] && ((i%10) < 7)) ) {
                    if ( (x < (ship4.frame.origin.x + 10)) && ((x+20) > (ship4.frame.origin.x + 10)) &&
                        (y < (ship4.frame.origin.y + 10)) && ((y+20) > (ship4.frame.origin.y + 10)) ) {
                        triggered = true;
                        [ship4 setFrame:CGRectMake(x, y, ship4.frame.size.width, ship4.frame.size.height)];
                        for( int j = 0; j < 4; j++ ) {
                            if ([ship4.text isEqualToString:@"v"]) {
                                if (playerTurn == true) { p1ship4[j+2] = @(i+(j*10)); }
                                else { p2ship4[j+2] = @((i+(j*10))); }
                            }
                            else {
                                if (playerTurn == true) { p1ship4[j+2] = @(i+j); }
                                else { p2ship4[j+2] = @(i+j); }
                            }
                        }
                        if (playerTurn == true) { [self shipConflictCheck:p1ship4];}
                        else { [self shipConflictCheck:p2ship4]; }
                    }
                }
                break;
            case 5:
                if ( ([ship5.text isEqualToString:@"v"] && (i<60)) || ([ship5.text isEqualToString:@"h"] && ((i%10) < 6)) ) {
                    if ( (x < (ship5.frame.origin.x + 10)) && ((x+20) > (ship5.frame.origin.x + 10)) &&
                        (y < (ship5.frame.origin.y + 10)) && ((y+20) > (ship5.frame.origin.y + 10)) ) {
                        triggered = true;
                        [ship5 setFrame:CGRectMake(x, y, ship5.frame.size.width, ship5.frame.size.height)];
                        for( int j = 0; j < 5; j++ ) {
                            if ([ship5.text isEqualToString:@"v"]) {
                                if (playerTurn == true) { p1ship5[j+2] = @(i+(j*10)); }
                                else { p2ship5[j+2] = @((i+(j*10))); }
                            }
                            else {
                                if (playerTurn == true) { p1ship5[j+2] = @(i+j); }
                                else { p2ship5[j+2] = @(i+j); }
                            }
                        }
                        if (playerTurn == true) { [self shipConflictCheck:p1ship5];}
                        else { [self shipConflictCheck:p2ship5]; }
                    }
                }
                break;
            default:
                break;
                
        }
        x += 20;
    }
    if (triggered == false) {
        switch (selectedShip) {
            case 1:
                for( int j = 0; j < 2; j++ ) {
                    if (playerTurn == true) { p1ship1[j+2] = @(j+100); }
                    else { p2ship1[j+2] = @(j+100); }
                }
                break;
            case 2:
                for( int j = 0; j < 3; j++ ) {
                    if (playerTurn == true) { p1ship2[j+2] = @(j+102); }
                    else { p2ship2[j+2] = @(j+102); }
                }
                break;
            case 3:
                for( int j = 0; j < 3; j++ ) {
                    if (playerTurn == true) { p1ship3[j+2] = @(j+105); }
                    else { p2ship3[j+2] = @(j+105); }
                }
                break;
            case 4:
                for( int j = 0; j < 4; j++ ) {
                    if (playerTurn == true) { p1ship4[j+2] = @(j+108); }
                    else { p2ship4[j+2] = @(j+108); }
                }
                break;
            case 5:
                for( int j = 0; j < 5; j++ ) {
                    if (playerTurn == true) { p1ship5[j+2] = @(j+112); }
                    else { p2ship5[j+2] = @(j+112); }
                }
                break;
            default:
                break;
        }
    }
    if (selectedShip != 0 ) {
        BOOL set = true;
        if (playerTurn == true) {
            if ([p1ship1[2] isEqual:@(100)]) { set = false; }
            if ([p1ship2[2] isEqual:@(102)]) { set = false; }
            if ([p1ship3[2] isEqual:@(105)]) { set = false; }
            if ([p1ship4[2] isEqual:@(108)]) { set = false; }
            if ([p1ship5[2] isEqual:@(112)]) { set = false; }
        }
        else {
            if ([p2ship1[2] isEqual:@(100)]) { set = false; }
            if ([p2ship2[2] isEqual:@(102)]) { set = false; }
            if ([p2ship3[2] isEqual:@(105)]) { set = false; }
            if ([p2ship4[2] isEqual:@(108)]) { set = false; }
            if ([p2ship5[2] isEqual:@(112)]) { set = false; }
        }
        if (set == true) { allShipsSet.hidden = false;}
        else { allShipsSet.hidden = true; }
    }
    
    selectedShip = 0;
}

- (void)shipConflictCheck:(NSMutableArray*) currentShip {
    
    // checks to see if a ship is being dropped on another ship
    // if so, sets the ship location back to its original starting position
    
    int currentShipIndex = (int)[currentShip[0] integerValue];
    NSMutableArray *currentList;
    currentList = [[NSMutableArray alloc] init];
    if (playerTurn == true ) {
        if (currentShipIndex != 1) {
            for( int j = 0; j < 2; j++ ) {
                [currentList addObject: p1ship1[j+2] ];
            }
        }
        if (currentShipIndex != 2) {
            for( int j = 0; j < 3; j++ ) {
                [currentList addObject: p1ship2[j+2] ];
            }
        }
        if (currentShipIndex != 3) {
            for( int j = 0; j < 3; j++ ) {
                [currentList addObject: p1ship3[j+2] ];
            }
        }
        if (currentShipIndex != 4) {
            for( int j = 0; j < 4; j++ ) {
                [currentList addObject: p1ship4[j+2] ];
            }
        }
        if (currentShipIndex != 5) {
            for( int j = 0; j < 5; j++ ) {
                [currentList addObject: p1ship5[j+2] ];
            }
        }
    }
    else {
        if (currentShipIndex != 1) {
            for( int j = 0; j < 2; j++ ) {
                [currentList addObject: p2ship1[j+2] ];
            }
        }
        if (currentShipIndex != 2) {
            for( int j = 0; j < 3; j++ ) {
                [currentList addObject: p2ship2[j+2] ];
            }
        }
        if (currentShipIndex != 3) {
            for( int j = 0; j < 3; j++ ) {
                [currentList addObject: p2ship3[j+2] ];
            }
        }
        if (currentShipIndex != 4) {
            for( int j = 0; j < 4; j++ ) {
                [currentList addObject: p2ship4[j+2] ];
            }
        }
        if (currentShipIndex != 5) {
            for( int j = 0; j < 5; j++ ) {
                [currentList addObject: p2ship5[j+2] ];
            }
        }
    }
    int pass = true;
    for (int i = 0; (i<[currentList count]); i++) {
        for (int j = 0; j<([currentShip count] - 2); j++ ) {
            if ( [currentShip[j+2] isEqual: currentList[i]] ) { pass = false; }
        }
    }
    if (pass == false) {
        switch (currentShipIndex) {
            case 1:
                for( int j = 0; j < 2; j++ ) {
                    if (playerTurn == true) { p1ship1[j+2] = @(j+100); }
                    else { p2ship1[j+2] = @(j+100); }
                }
                [ship1 setFrame:CGRectMake(50, 70, ship1.frame.size.width, ship1.frame.size.height)];
                break;
            case 2:
                for( int j = 0; j < 3; j++ ) {
                    if (playerTurn == true) { p1ship2[j+2] = @(j+102); }
                    else { p2ship2[j+2] = @(j+102); }
                }
                [ship2 setFrame:CGRectMake(90, 110, ship2.frame.size.width, ship2.frame.size.height)];
                break;
            case 3:
                for( int j = 0; j < 3; j++ ) {
                    if (playerTurn == true) { p1ship3[j+2] = @(j+105); }
                    else { p2ship3[j+2] = @(j+105); }
                }
                [ship3 setFrame:CGRectMake(130, 150, ship3.frame.size.width, ship3.frame.size.height)];
                break;
            case 4:
                for( int j = 0; j < 4; j++ ) {
                    if (playerTurn == true) { p1ship4[j+2] = @(j+108); }
                    else { p2ship4[j+2] = @(j+108); }
                }
                [ship4 setFrame:CGRectMake(170, 190, ship4.frame.size.width, ship4.frame.size.height)];
                break;
            case 5:
                for( int j = 0; j < 5; j++ ) {
                    if (playerTurn == true) { p1ship5[j+2] = @(j+112); }
                    else { p2ship5[j+2] = @(j+112); }
                }
                [ship5 setFrame:CGRectMake(210, 230, ship5.frame.size.width, ship5.frame.size.height)];
                break;
            default:
                break;
        }
    }
    [currentList addObject:@(1)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
