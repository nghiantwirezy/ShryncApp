//
//  AudioPlayerViewController.m
//  My Therapist
//
//  Created by Yexiong Feng on 7/13/14.
//  Copyright (c) 2014 ApplePieHealing. All rights reserved.
//

#import "AudioPlayerViewController.h"
#import "FSAudioStream.h"
#import "AudioTrackCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "UserSession.h"
#import "Feeling.h"
#import "AudioTrack.h"
#import "FeelingRecord.h"
#import "AppDelegate.h"

#define AUDIO_TRACK_CELL_ID @"AUDIO_TRACK_CELL_ID"

#define MEDIA_URL @"https://secure.shrync.com/api/feelings/media"
#define TOKEN_PARAM_KEY @"token"
#define TYPE_PARAM_KEY @"type"
#define MAIN_FEELING_INDEX_KEY @"mainfeelingindex"
#define PAGE_SIZE_KEY @"count"
#define TITLE_KEY @"title"
#define DESCRIPTION_KEY @"description"
#define MEDIA_URL_KEY @"media"

#define TITLE @"MY AUDIO THERAPY"

@interface AudioPlayerViewController ()

@end

@implementation AudioPlayerViewController {
  FSAudioStream *_audioStream;
  NSInteger _currentTrackIndex;
  BOOL _isPaused;
  
  NSMutableArray *_tracks;
  
  UIBarButtonItem *_backButtonItem;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)popBack
{
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  _audioStream = [[FSAudioStream alloc] init];
  [_audioStream setStrictContentTypeChecking:NO];
  
  __weak typeof(self) weakSelf = self;
  _audioStream.onCompletion = ^(void) {
    [weakSelf nextButtonPressed];
  };
  _tracks = [[NSMutableArray alloc] init];
  
  UIImage *backImage = [UIImage imageNamed:@"back button.png"];
  UIButton *backButton = [[UIButton alloc] initWithFrame: CGRectMake(0, 0, backImage.size.width, backImage.size.height)];
  [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
  [backButton addTarget:self action:@selector(popBack) forControlEvents:UIControlEventTouchUpInside];
  _backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
  
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 35)];
  titleLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:21.0f];
  titleLabel.text = NSLocalizedString(TITLE, nil);
  titleLabel.textColor = [UIColor colorWithRed:221.0 / 255 green:221.0 / 255 blue:221.0 / 255 alpha:1];
  titleLabel.textAlignment = NSTextAlignmentCenter;
  self.navigationItem.titleView = titleLabel;
  
  self.trackTitleLabel.font = [UIFont fontWithName:@"LeagueGothic-Regular" size:24.0f];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  [self.navigationController setNavigationBarHidden:NO animated:YES];
  
  if (self.navigationController.viewControllers.count > 1) {
    self.navigationItem.leftBarButtonItem = _backButtonItem;
  } else {
    self.navigationItem.leftBarButtonItem = ((AppDelegate *) [[UIApplication sharedApplication] delegate]).revealMenuButtonItem;
  }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _tracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  AudioTrackCell *cell = [tableView dequeueReusableCellWithIdentifier:AUDIO_TRACK_CELL_ID];
  if (cell == nil) {
    cell = [[AudioTrackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AUDIO_TRACK_CELL_ID];
  }
  [cell setTrack:[_tracks objectAtIndex:indexPath.row]];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 32;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  _currentTrackIndex = indexPath.row;
  
  [_audioStream stop];
  [self playPauseButtonPressed];
}

- (IBAction)playPauseButtonPressed
{
  [self.trackListTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentTrackIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
  AudioTrack *track = [_tracks objectAtIndex:_currentTrackIndex];
  self.iconView.image = track.feeling.feelingActiveIcon;
  self.trackTitleLabel.text = track.title;
  
  if ([_audioStream isPlaying]) {
    [_audioStream pause];
    _isPaused = !_isPaused;
  } else {
    AudioTrack *track = [_tracks objectAtIndex:_currentTrackIndex];
    [_audioStream playFromURL:track.url];
    _isPaused = NO;
  }
  
  UIImage *image = _isPaused ? [UIImage imageNamed:@"play.png"] : [UIImage imageNamed:@"pause.png"];
  [self.playPauseButton setImage:image forState:UIControlStateNormal];
  if (!_isPaused) {
    [self.trackListTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentTrackIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.trackListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentTrackIndex inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
  }
}

- (IBAction)nextButtonPressed
{
  if (_currentTrackIndex + 1 < _tracks.count) {
    _currentTrackIndex += 1;
    
    [_audioStream stop];
    [self playPauseButtonPressed];
  }
}

- (IBAction)prevButtonPressed
{
  if (_currentTrackIndex - 1 >= 0) {
    _currentTrackIndex -= 1;
    
    [_audioStream stop];
    [self playPauseButtonPressed];
  }
}

- (void)setFeelingRecord:(FeelingRecord *)feelingRecord
{
  if (_feelingRecord != feelingRecord) {
    _feelingRecord = feelingRecord;
    
    [_audioStream stop];
    _currentTrackIndex = 0;
    
    NSMutableString *mainFeelingIndexes = [NSMutableString stringWithFormat:@"%d", ((Feeling *)[self.feelingRecord.feelings objectAtIndex:0]).mainFeelingIndex];
    for (int i = 1; i < self.feelingRecord.feelings.count; ++i) {
      Feeling *feeling = [self.feelingRecord.feelings objectAtIndex:i];
      [mainFeelingIndexes appendFormat:@",%d", feeling.mainFeelingIndex];
    }
    
    NSDictionary *parameters = @{TOKEN_PARAM_KEY: [UserSession currentSession].sessionToken, TYPE_PARAM_KEY: @"1", MAIN_FEELING_INDEX_KEY: mainFeelingIndexes, PAGE_SIZE_KEY: @99};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager GET:MEDIA_URL parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
           NSMutableDictionary *feelingByIndex = [[NSMutableDictionary alloc] init];
           for (Feeling *feeling in self.feelingRecord.feelings) {
             [feelingByIndex setObject:feeling forKey:[NSNumber numberWithUnsignedInteger:feeling.mainFeelingIndex]];
           }
           
           [_tracks removeAllObjects];
           
           NSArray *results = responseObject;
           for (int i = results.count - 1; i >= 0; --i) {
             NSDictionary *dict = [results objectAtIndex:i];
             NSString *mainFeelingIndex = [dict objectForKey:MAIN_FEELING_INDEX_KEY];
             NSString *url = [dict objectForKey:MEDIA_URL_KEY];
             
             AudioTrack *track = [[AudioTrack alloc] init];
             Feeling *feeling = [feelingByIndex objectForKey:[NSNumber numberWithInteger:mainFeelingIndex.integerValue]];
             track.feeling = feeling;
             track.title = [dict objectForKey:TITLE_KEY];
             track.trackDesc = [dict objectForKey:DESCRIPTION_KEY];
             track.url = [NSURL URLWithString:url];
             
             [_tracks addObject:track];
           }
           
           _currentTrackIndex = 0;
           [self.playPauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
           
           [self.trackListTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_currentTrackIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
           AudioTrack *track = [_tracks objectAtIndex:_currentTrackIndex];
           self.iconView.image = track.feeling.feelingActiveIcon;
           self.trackTitleLabel.text = track.title;
           
           [self.trackListTableView reloadData];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           NSLog(@"%@", error);
         }];
  }
}

@end
