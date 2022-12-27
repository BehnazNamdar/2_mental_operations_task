%% This is a script of the First experiment of article by Jérôme Sackur , Stanislas Dehaene...
%  named "The cognitive architecture for chaining of two mental
%  operations" published in 2009.
%  the article address is ... doi:10.1016/j.cognition.2009.01.010
% 
% 
% written by: Behnaz Namdarzadeh
% 
% 
% last edition : 2022/05/10
%% Display Setup Module

% Define display parameters
whichScreen = max(Screen('screens'));
[width, height]=Screen('WindowSize',max(Screen('Screens')));

rect = [0 0 width height];

%rect = [1 1 800 600];
p.ScreenDistance = 60;  % in cm 
p.ScreenHeight = 30;    % in cm
p.ScreenGamma = 2;  % from monitor calibration
% p.maxLuminance = 100; % from monitor calibration
p.ScreenBackground = 0; % color of the background

% Open the display window, setup lookup table, and hide the mouse cursor

if exist('onCleanup', 'class'), oC_Obj = onCleanup(@()sca);
end % close any pre-existing PTB Screen window

%Prepare setup of imaging pipeline for onscreen window. 
PsychImaging('PrepareConfiguration'); % First step in starting pipeline
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');   % set up a 32-bit floatingpoint framebuffer
PsychImaging('AddTask', 'General', 'NormalizedHighresColorRange'); % normalize the color range ([0, 1] corresponds to [min, max])
PsychImaging('AddTask', 'General', 'EnablePseudoGrayOutput'); % enable high gray level resolution output with bitstealing
PsychImaging('AddTask', 'FinalFormatting', 'DisplayColorCorrection', 'SimpleGamma');  % set up Gamma correction method using simple power function for all color channels 
[windowPtr p.ScreenRect] = PsychImaging('OpenWindow', whichScreen, p.ScreenBackground,rect);  % Finishes the setup phase for imaging pipeline, creates an onscreen window, performs all remaining configuration steps
PsychColorCorrection('SetEncodingGamma', windowPtr, 1 / p.ScreenGamma);  % set Gamma for all color channels
HideCursor;  % Hide the mouse cursor

% Get frame rate and set screen font
p.ScreenFrameRate = FrameRate(windowPtr); % get current frame rate
Screen('TextFont', windowPtr, 'Arial'); % set the font for the screen to Arial
Screen('TextSize', windowPtr, 24); % set the font size for the screen to 24



%% 

% -----------------------
% set timing parameters
% -----------------------

fixDur = 1;              % duration of fixation point (ms) 
stimDur = 0.29;               % duration of stimulus (ms) 
%resDur = 1000;              % duration of response time (ms)  



% -----------------------
% set trials parameters
% -----------------------


% we have 3 block types 
blockType = [1 2 3];

% set number of repetiyio per block
blockRep = 10;

% Make the matrix which will determine our block combinations
blockMatrixBase = repmat(blockType, 1 , 2); 
blockMatrixBase = Shuffle(blockMatrixBase); 



% we have 4 stimulus 
stimulus = [ 2 4 6 8];

% set number of repetiyio per block
stimRep = 5;

% Make the matrix which will determine our trials combinations
stimMatrix = repmat(stimulus, 1, 2);
stimMatrix = Shuffle(stimMatrix);


for i = 1 : length(blockMatrixBase)

    
    for j = 1 : length(stimMatrix)
    
    blockStruc(i).nblock = i;
    blockStruc(i).blockType = blockMatrixBase(i);    
    %response(j).ntrial = block * length(stimMatrix) + trial ;
    response(j).stimulus = stimMatrix(j);
    
    % 3 block condition 


        if blockStruc(i).blockType == 1   % simple block time 
            if response(j).stimulus == 2 || response(j).stimulus == 4
                response(j).calcRes = 'f' ;
            else 
                response(j).calcRes = 'j';
            end

        elseif blockStruc(i).blockType == 2  % composite add chained
            if response(j).stimulus == 2 || response(j).stimulus == 8   
                response(j).calcRes = 'f' ;
            else 
                response(j).calcRes = 'j';
            end

        elseif  blockStruc(i).blockType == 3  % composite minus chained 
            if response(j).stimulus == 4 || response(j).stimulus == 6
                response(j).calcRes = 'f' ;
            else 
                response(j).calcRes = 'j';
            end

        end

        
    end
    
end





% ---------------------
% Keyboard information
% ---------------------

% Define the keyboard keys that are listened for. We will be using the f
% and j arrow keys as response keys for the task and the escape key as
% a exit key
% escapeKey = KbName('ESCAPE');
% smallerThan = KbName('f');
% biggerThan = KbName('j');


%% fixation point parameters


CrossCm = 0.6;

crossLengh = mlreportgen.utils.units.toPixels(CrossCm, "cm");
crossColor=255;
crossWidth=3;

%set start & end points of line
crossLines=[-crossLengh , 0 ; crossLengh , 0 ; 0 , -crossLengh ; 0 , crossLengh];
crossLines=crossLines';

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(p.ScreenRect);


%% instruction 

RestrictKeysForKbCheck(KbName('space'));
text = 'You will have to compare the stimuli \n 2, 4, 6, 8 \n to the fixed reference 5.\n The experiment contained three conditions\n two of which required them to apply a mental transformation\n to the stimulus before the comparison.\n Press Space to continue';

DrawFormattedText(windowPtr, text ,'center', 'center', 255);
Screen('Flip', windowPtr);
KbWait();


%%
% -------------------
% Experimental loop
% -------------------



for block = 1: length(blockStruc)
    WaitSecs(0.5);
    RestrictKeysForKbCheck([]);
    RestrictKeysForKbCheck(KbName('space'));
    Screen('TextSize', windowPtr, 24);
    if blockStruc(block).blockType == 1   % simple block time
   
        text = 'Indicate if the shown number is\n smaller than 5 by pressing f or \n bigger than 5 by pressing j. \n Press Space to continue';
        DrawFormattedText(windowPtr, text ,'center', 'center', 255);
        Screen('Flip', windowPtr);
        KbWait();
        WaitSecs(0.5);
    elseif blockStruc(block).blockType == 2  % composite add chained
        text = 'Indicate if the shown number @ + 2 is\n smaller than 5 by pressing f or \n bigger than 5 by pressing j. \n Press Space to continue';
        DrawFormattedText(windowPtr, text ,'center', 'center', 255);
        Screen('Flip', windowPtr);
        KbWait();
        WaitSecs(0.5);
    elseif  blockStruc(block).blockType == 3  % composite minus chained
        text = 'Indicate if the shown number @ - 2 is\n smaller than 5 by pressing f or \n bigger than 5 by pressing j. \n Press Space to continue';
        DrawFormattedText(windowPtr, text ,'center', 'center', 255);
        Screen('Flip', windowPtr);
        KbWait();
        WaitSecs(0.5);
    end
    
    Screen('Flip', windowPtr);

    
    %  Make a loop for a trial
    
    for trial = 1: length(response)
        
        
        % show the fixation point for 1000 ms
        
        Screen('DrawLines',windowPtr,crossLines,crossWidth,crossColor,[xCenter,yCenter]);
        Screen('Flip',windowPtr);
        WaitSecs(fixDur);
        
        
        % show the stimulus for 29 ms
        Screen('TextSize', windowPtr, 30);
        DrawFormattedText(windowPtr, num2str(stimMatrix(trial)),'center', 'center', 255)
        Screen('Flip', windowPtr);
        WaitSecs(stimDur);

        % wait for the subject to press a key  - Check the keyboard
        Screen('Flip',windowPtr);
        
        tStart = GetSecs();
        RestrictKeysForKbCheck([]);
        RestrictKeysForKbCheck([KbName('f'), KbName('j')]);
        keyIsDown = 0;
        while ~keyIsDown
            [keyIsDown,secs,keyCode]=KbCheck(-1);
        end
        keypressed = KbName(find(keyCode));
        if keypressed == 'f'
            reskey = 'f';
        elseif keypressed == 'j'
            reskey = 'j';
        end
        rt = secs - tStart;
    % Record the trial data into out data matrix
    % I am recording everything here , may be just saving rt and response
    % keys are enough
    
    
    response(trial).reactionTime = rt;
    response(trial).responsekey = reskey ;
    response(trial).accuracy = ismember(response(trial).responsekey,response(trial).calcRes);
    N = length(response);
    chroExp(N * (block -1) + trial).ID = N * (block -1) + trial;
    chroExp(N * (block -1) + trial).nblock = block;
    chroExp(N * (block -1) + trial).rt = response(trial).reactionTime;
    chroExp(N * (block -1) + trial).resp = response(trial).responsekey;
    chroExp(N * (block -1) + trial).accu = response(trial).accuracy;
    

    end
    
    
    RestrictKeysForKbCheck([]);
    RestrictKeysForKbCheck(KbName('space'));
    sum([response(:).accuracy])

    if length(response) - sum([response(:).accuracy]) > 3 
        text = 'You have more than 3 errors. \n you should pay more attention to the task. \n Press Space to continue';
        Screen('TextSize', windowPtr, 24);
        DrawFormattedText(windowPtr, text ,'center', 'center', 255);
        Screen('Flip', windowPtr);
        KbWait();
        WaitSecs(0.5);
    end
        

end

save chroExp.mat response chroExp;             
sca;     
 
