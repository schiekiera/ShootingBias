% Essien, I., Stelter, M., Kalbe, F., Koehler, A., Mangels, J., & 
% Meliß, S. (2017). The shooter bias: Replicating the classic effect 
% and introducing a novel paradigm. Journal of Experimental Social 
% Psychology, 70, 41-47.

% In this Experiment, participants perform the shooter task (Correll
% et al., 2002) with unarmed and armed White and Arab-Muslim targets.

% Design: 2 x 2 Design with repated Measures
% Factor 1. Target Ethnicity: White vs. Arab-Muslim
% Factor 2. Object Type: gun vs. object
% Repeated Measurement: 20 x same Background

% Stimuli: 80 picture pairs --> 1. Background 2. Background with person
% Stimulis presented here are from the original study and were sent to me
% via e-mail by the main author Dr. Iniobong Essien.

% Thank you very much again, Dr. Essien!

% Test part: 4 Stimuli --> Original study 20
% Performance part : 80 Stimuli

% Hypotheses from the original study:
% We expected participants' reaction times to be faster for armed
% Arab-Muslim targets than for armed White targets. Conversely,
% reaction times should be slower for unarmed Arab-Muslim targets
% than for unarmed White targets. Furthermore, we hypothesized
% that participants show more liberal response biases (i.e., shooting
% thresholds) for Arab-Muslim targets than for White targets.


%% Clear the workspace and the screen
sca;
close all;
clear;
clc;

%% 0.1. Experiment parameters

% set id 
id = 123;

% Set initial settings
KbName('UnifyKeyNames')
addpath('./functions');
addpath('./images');


%% Generate Design
% call function generate_design(id)
% generates a 80 x 8 randomized design table containing the following variables
%
% weapon                =   Individual wearing a weapon (1 = gun; 0 = no gun)
% ethnicity             =   Ethnicity (1 = Arab; 0 = Caucasian)
% stimulus number       =   Stimulus Number (1:20)
% weapon_levels         =   Weapon Levels ("armed","unarmed")
% ethnicity_levels      =   Ethnicity Levels ("Arab","Caucasian")
% image                 =   80 Images of Persons: "1a.jpg" --> "20d.jpg"
%               Xa.jpg  =   Unarmed & caucasian
%               Xb.jpg  =   Armed & caucasian
%               Xc.jpg  =   Unarmed & arab
%               Xd.jpg  =   Armed & arab
% image_bg              =   20 Images of Background: "1.jpg" --> "20.jpg" 
% expected_response     =   Expected responses ("LeftArrow","DownArrow")

design = generate_design(id);

%% ntrials
% Set experimental parameters
ntrials=80;                                 % Number of trials
trial_length=ntrials;                       % Possible to set to smaller number of trials e.g. 4 (=used to test shorter versions of experiment)

%% Storing responses
% empty vectors for storing responses
response =          strings(ntrials, 1);                
rt =                NaN * ones(ntrials, 1);                    
correct =           NaN * ones(ntrials, 1);     
tooslow =           NaN * ones(ntrials, 1);    
hit =               NaN * ones(ntrials, 1);   
false_alarm =       NaN * ones(ntrials, 1);     
miss =              NaN * ones(ntrials, 1);     
correct_rejection = NaN * ones(ntrials, 1); 

%% Points
% Dynamical parameter. Changes as a function of test performance.
points=0;                       

%% Timing
% Time variables A (Self set)
interval=0.5:0.01:1.5;                      % Pause between Stimuli: Setting a uniformely distributed vector between 0.5 and 1.5 seconds
i=randperm(length(interval),ntrials);       % Selecting randomly ntrials numbers of the 1 : 101 time interval index vector length(interval) --> stored in i
betweenConInterval=interval(i);             % ntrails time interval containing vector = Indexed by i

%% Test phase
% parameters for test phase
ntest=4;
test_points=0;                             
test_bg=["test_1.jpg","test_2.jpg","test_3.jpg","test_4.jpg"];
test=["test_1a.jpg","test_2a.jpg","test_3a.jpg","test_4a.jpg"];
test_expected_response=["LeftArrow","RightArrow","LeftArrow","RightArrow"];
test_response=strings(ntest, 1);      

%% Response Sets
% LeftArrow     = shoot
% RightArrow    = no shoot
responseSet = {'LeftArrow', 'RightArrow'};
responseSetCodes = KbName(responseSet);

% Space         = continue
responseSet1 = {'Space'};
responseSetCodes1 = KbName(responseSet1);

%% Essien 2017
% Further experimental parameters directly derived from Essien's (2017) script
% 1. Rewards/Punishes
HitReward = 10;                                         
MissPunish = 40;
CRReward = 5;
FAPunish = 20;
NoresponsePunish = 10;

% Time variables B (Essien)
fixationduration = 0.5;     %s for WaitSec
timeout =850;               %ms

%% 0.2. Screen Settings
% Sync Test
Screen('Preference', 'SkipSyncTests', 1);
PsychDefaultSetup(2);

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if available
screenNumber = max(screens);

% Define colors
white = WhiteIndex(screenNumber);
black = BlackIndex(screenNumber);
grey = white / 2;

% Open an on screen window
 [window, windowRect] = PsychImaging('OpenWindow', screenNumber);

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);
 
% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);



%% 1. Show Instructions
fileID = fopen('material/instructions.txt', 'r', 'n', 'UTF-8' );
instructions = fread(fileID,'*char')';
fclose(fileID);

Screen('TextSize', window, 25); 
Screen('TextFont', window, 'Courier'); 
DrawFormattedText(window, instructions, 'center', 'center', black) 

% Initial flip
Screen('Flip', window);

% wait until space is pressed on any of the attached keyboards
keyIsDown = 0;
done = false;
while ~done
    [keyIsDown, t1, keyCode, deltaSecs] = KbCheck();
    if keyIsDown && sum(keyCode)==1 	% only a single key pressed
	    if any(keyCode(responseSetCodes1))
		    done = true;
	    end
    end
end



%% 2.1. Test Trials
% for loop containing 4 picture pairs
for trial = 1:ntest

    %% First Element: Text
    Screen('TextSize', window, 50); 
    Screen('TextFont', window, 'Courier'); 
    DrawFormattedText(window, 'Testphase: Warten!', 'center', 'center', black) 

    % Draw Text 1
    test_points_string = sprintf('Test-Punkte:%4.0f', test_points);
    DrawFormattedText(window, test_points_string, 1400, 200, black) 

    % First Flip
	Screen('Flip', window);

    % Wait
    WaitSecs(1);


    %% Second Element: Background image
    % Background: Image present
    image_present_bg = imread(test_bg(trial));

    % Texture
    image_texture_bg = Screen('MakeTexture', window, image_present_bg);

     % Draw Text 2
    DrawFormattedText(window, test_points_string, 1400, 200, black) 

    % Draw Screen
    Screen('DrawTexture', window, image_texture_bg, [], [], 0);
    
    % Second Flip
	Screen('Flip', window);

    % Wait: Only in test trial set to constant value: 1s
    WaitSecs(1);


    %% Third Element: Background image
    % Image present
    image_present = imread(test(trial));

    % Texture
    image_texture = Screen('MakeTexture', window, image_present);

    % Draw Text  3
    DrawFormattedText(window, test_points_string, 1400, 200, black) 

    % Draw Screen
    Screen('DrawTexture', window, image_texture, [], [], 0);

    % Third Flip
	Screen('Flip', window);

    % t0
    t0 = GetSecs;
    

    %% Key Press --> Action
    % wait until LeftArrow or DownArrow is pressed
    keyIsDown = 0;
    done = false;
    while ~done
	    [keyIsDown, t1, keyCode, deltaSecs] = KbCheck();
        rt_check = (1000 * (t1-t0));
	    if keyIsDown && sum(keyCode)==1	% only a single key pressed
		    if any(keyCode(responseSetCodes))
                test_response(trial) = string(KbName(keyCode));
                % hit
                if test_response(trial)=="LeftArrow" && test_expected_response(trial)=="LeftArrow"
                    DrawFormattedText(window, 'Treffer! +10 Punkte', 'center', 'center', black) 
                    DrawFormattedText(window, test_points_string, 1400, 200, black) 
                    Screen('Flip', window);
                    WaitSecs(1);
                    test_points=test_points+HitReward;
			        done = true;
                % false alarm
                elseif test_response(trial)=="LeftArrow" && test_expected_response(trial)=="RightArrow"
                    DrawFormattedText(window, 'Falscher Alarm! -20 Punkte', 'center', 'center', black) 
                    DrawFormattedText(window, test_points_string, 1400, 200, black) 
                    Screen('Flip', window);
                    WaitSecs(1);
                    test_points=test_points-FAPunish;
                    done = true;
                % correct rejection
                elseif test_response(trial)=="RightArrow" && test_expected_response(trial)=="RightArrow"
                    DrawFormattedText(window, 'Richtige Ablehnung! +5 Punkte', 'center', 'center', black) 
                    DrawFormattedText(window, test_points_string, 1400, 200, black) 
                    Screen('Flip', window);
                    WaitSecs(1);
                    test_points=test_points+CRReward;
                    done = true;
                end       
                % miss
                elseif test_response(trial)=="RightArrow" && test_expected_response(trial)=="LeftArrow"
                    DrawFormattedText(window, 'Verpasst! -40 Punkte', 'center', 'center', black) 
                    DrawFormattedText(window, test_points_string, 1400, 200, black) 
                    Screen('Flip', window);
                    WaitSecs(1);
                    test_points=test_points-MissPunish;
                    done = true;
            end
            % if none of these keys is pressed after 850 ms --> show next image
            elseif rt_check > timeout 
                 DrawFormattedText(window, 'Zu langsam! -10 Punkte', 'center', 'center', black) 
                 DrawFormattedText(window, test_points_string, 1400, 200, black) 
                 Screen('Flip', window);
                 WaitSecs(1);
                 test_points=test_points-NoresponsePunish;
                 done = true;
        end
    end
end



%% 2.2. End test trial
% Draw message for participant
Screen('TextSize', window, 35); 
Screen('TextFont', window, 'Courier'); 
DrawFormattedText(window, 'Sie haben die Test-Phase beendet. Drücken Sie die LEERTASTE zum fortfahren!', 'center', 'center', black) 
Screen('Flip', window);

% wait until space is pressed on any of the attached keyboards
keyIsDown = 0;
done = false;
while ~done
    [keyIsDown, t1, keyCode, deltaSecs] = KbCheck();
    if keyIsDown && sum(keyCode)==1 	% only a single key pressed
	    if any(keyCode(responseSetCodes1))
		    done = true;
	    end
    end
end



%% 3. Main part: For Loop Presentation
% loops through all 80/ntrials picture pairs
for trial = 1:trial_length

    %% First Element: Text
    Screen('TextSize', window, 50);                                
    Screen('TextFont', window, 'Courier');                  
    DrawFormattedText(window, 'Warten!', 'center', 'center', black) 

    % Draw Text  1
    points_string = sprintf('Punkte:%4.0f', points);
    DrawFormattedText(window, points_string, 1400, 200, black) 

    % First Flip
	Screen('Flip', window);

    % Wait
    WaitSecs(1);

    %% Second Element: Background image
    % Background: Image present
    image_present_bg = imread(design.image_bg(trial));

    % Texture
    image_texture_bg = Screen('MakeTexture', window, image_present_bg);

    % Draw Text  2
    DrawFormattedText(window, points_string, 1400, 200, black) 

    % Draw Screen
    Screen('DrawTexture', window, image_texture_bg, [], [], 0);
    
    % Second Flip
	Screen('Flip', window);

    % Wait: changes as a function of beetweenConInterval -->
    % Set to avoid time habituation
    WaitSecs(betweenConInterval(trial));

    %% Third Element: Background image
    % Image present
    image_present = imread(design.image(trial));

    % Texture
    image_texture = Screen('MakeTexture', window, image_present);

    % Draw Text 3
    DrawFormattedText(window, points_string, 1400, 200, black) 

    % Draw Screen
    Screen('DrawTexture', window, image_texture, [], [], 0);

    % Third Flip
	Screen('Flip', window);

    % t0
    t0 = GetSecs;
    
    %% Key Press --> Action & Measure Responses
    % wait until LeftArrow or DownArrow is pressed
    keyIsDown = 0;
    done = false;
    while ~done
	    [keyIsDown, t1, keyCode, deltaSecs] = KbCheck();
        rt_check = (1000 * (t1-t0));
	    if keyIsDown && sum(keyCode)==1	% only a single key pressed
		    if any(keyCode(responseSetCodes))
                % store rt and response
                rt(trial) = 1000 * (t1-t0);
                response(trial) = string(KbName(keyCode));
                % correct hit
                if response(trial)=="LeftArrow" && design.expected_response(trial)=="LeftArrow"
                    DrawFormattedText(window, 'Treffer! +10 Punkte', 'center', 'center', black) 
                    DrawFormattedText(window, points_string, 1400, 200, black) 
                    Screen('Flip', window);
                    WaitSecs(1);
                    points=points+HitReward;
                    correct(trial)           =  1;
                    tooslow(trial)           =  0;
                    hit(trial)               =  1;
                    false_alarm(trial)       =  0;
                    correct_rejection(trial) =  0;
                    miss(trial)              =  0;
			        done = true;
                elseif response(trial)=="LeftArrow" && design.expected_response(trial)=="RightArrow"
                    DrawFormattedText(window, 'Falscher Alarm! -20 Punkte', 'center', 'center', black) 
                    DrawFormattedText(window, points_string, 1400, 200, black) 
                    Screen('Flip', window);
                    WaitSecs(1);
                    points=points-FAPunish;
                    correct(trial)           =  0;
                    tooslow(trial)           =  0;
                    hit(trial)               =  0;
                    false_alarm(trial)       =  1;
                    correct_rejection(trial) =  0;
                    miss(trial)              =  0;
			        done = true;
                elseif response(trial)=="RightArrow" && design.expected_response(trial)=="RightArrow"
                    DrawFormattedText(window, 'Richtige Ablehnung! +5 Punkte', 'center', 'center', black) 
                    DrawFormattedText(window, points_string, 1400, 200, black) 
                    Screen('Flip', window);
                    WaitSecs(1);
                    points=points+CRReward;
                    correct(trial)           =  1;
                    tooslow(trial)           =  0;
                    hit(trial)               =  0;
                    false_alarm(trial)       =  0;
                    correct_rejection(trial) =  1; 
                    miss(trial)              =  0;
			        done = true;
                elseif response(trial)=="RightArrow" && design.expected_response(trial)=="LeftArrow"
                    DrawFormattedText(window, 'Verpasst! -40 Punkte', 'center', 'center', black) 
                    DrawFormattedText(window, points_string, 1400, 200, black) 
                    Screen('Flip', window);
                    WaitSecs(1);
                    points=points-MissPunish;
                    correct(trial)           =  0;
                    tooslow(trial)           =  0;
                    hit(trial)               =  0;
                    false_alarm(trial)       =  0;
                    correct_rejection(trial) =  0;
                    miss(trial)              =  1;
			        done = true;
                end
            end
            % if none of these keys is pressed after 850 ms --> show next image
            elseif rt_check > timeout 
                 DrawFormattedText(window, 'Zu langsam! -10 Punkte', 'center', 'center', black) 
                 DrawFormattedText(window, points_string, 1400, 200, black) 
                 Screen('Flip', window);
                 rt(trial) = NaN;
                 WaitSecs(1);
                 points=points-NoresponsePunish;
                 correct(trial)=0;
                 tooslow(trial)=1;
                 done=true;
        end
    end
end



%% 4. Store Results
results=design;
% add vectors response, correct,tooslow and rewards to the table
results.response=response;
results.correct=correct;
results.tooslow=tooslow;
results.hit=hit;
results.false_alarm=false_alarm;
results.correct_rejection=correct_rejection;
results.miss=miss;

% define folder and name
outfile_result_name = ['results/Results_Essien_2017_' num2str(id), '.dat'];

% write table
writetable(results, outfile_result_name,'Delimiter','\t','Encoding','UTF-8');



%% 5. Outro
% 5.1. Present Results to Participant
% call function present_results(results,trial_length,points)
all_txt=present_results(results,trial_length,points);

% Present results
Screen('TextSize', window, 25); 
Screen('TextFont', window, 'Courier'); 
DrawFormattedText(window, all_txt, 'center', 'center', black) 
Screen('Flip', window);

% wait until space is pressed on any of the attached keyboards
keyIsDown = 0;
done = false;
while ~done
    [keyIsDown, t1, keyCode, deltaSecs] = KbCheck();
    if keyIsDown && sum(keyCode)==1 	% only a single key pressed
	    if any(keyCode(responseSetCodes1))
		    done = true;
	    end
    end
end

WaitSecs(0.5);


% 5.2. Debriefing
fileID2 = fopen('material/debriefing.txt', 'r', 'n', 'UTF-8' );
debriefing = fread(fileID2,'*char')';
fclose(fileID2);

Screen('TextSize', window, 25); 
Screen('TextFont', window, 'Courier'); 
DrawFormattedText(window, debriefing, 'center', 'center', black) 

% Final flip
Screen('Flip', window);

% wait until space is pressed on any of the attached keyboards
keyIsDown = 0;
done = false;
while ~done
    [keyIsDown, t1, keyCode, deltaSecs] = KbCheck();
    if keyIsDown && sum(keyCode)==1 	% only a single key pressed
	    if any(keyCode(responseSetCodes1))
		    done = true;
	    end
    end
end


% Clear the screen
sca;