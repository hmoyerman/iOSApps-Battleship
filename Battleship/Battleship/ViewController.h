//
//  ViewController.h
//  Battleship
//
//  Created by Henry Moyerman on 10/16/15.
//  Copyright (c) 2015 Henry Moyerman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property BOOL onePlayer;
@property BOOL playerTurn;
@property BOOL goesFirst;
@property BOOL endGame;
@property BOOL SALVO;
@property BOOL randomPlay;
@property BOOL attackReady;
@property BOOL ARM;
@property BOOL p1ShipsSet;
@property BOOL p2ShipsSet;
@property int hitShip;
@property int attackTile;
@property int originHit;
@property int currentHit;
@property int hitDirection;
@property int aiOffset;
@property int randomShips;

@property int p1hitCounter;
@property int p2hitCounter;

@property int p1shipHitCounter;
@property int p2shipHitCounter;

@property (nonatomic, retain) NSMutableArray *topGrid;
@property (nonatomic, retain) NSMutableArray *bottomGrid;
@property (nonatomic, retain) NSMutableArray *p1guesses;
@property (nonatomic, retain) NSMutableArray *p2guesses;
@property (nonatomic, retain) NSMutableArray *p1board;
@property (nonatomic, retain) NSMutableArray *p2board;
@property (nonatomic, retain) NSMutableArray *names;

@property (nonatomic, retain) NSMutableArray *p1ship1;
@property (nonatomic, retain) NSMutableArray *p1ship2;
@property (nonatomic, retain) NSMutableArray *p1ship3;
@property (nonatomic, retain) NSMutableArray *p1ship4;
@property (nonatomic, retain) NSMutableArray *p1ship5;
@property (nonatomic, retain) NSMutableArray *p2ship1;
@property (nonatomic, retain) NSMutableArray *p2ship2;
@property (nonatomic, retain) NSMutableArray *p2ship3;
@property (nonatomic, retain) NSMutableArray *p2ship4;
@property (nonatomic, retain) NSMutableArray *p2ship5;

@property int p1ship1Counter;
@property int p1ship2Counter;
@property int p1ship3Counter;
@property int p1ship4Counter;
@property int p1ship5Counter;
@property int p2ship1Counter;
@property int p2ship2Counter;
@property int p2ship3Counter;
@property int p2ship4Counter;
@property int p2ship5Counter;

@property UIAlertView *notEmptyAlert;

@property UILabel *mainTitle;
@property UILabel *guessesTitle;
@property UILabel *boardTitle;
@property UILabel *hitTitle;

@property UILabel *ship1;
@property UILabel *ship2;
@property UILabel *ship3;
@property UILabel *ship4;
@property UILabel *ship5;
@property UILabel *blanket;
@property UILabel *dropRotateBox;
@property UIButton *attackButton;
@property UIButton *allShipsSet;
@property int selectedShip;


@end

