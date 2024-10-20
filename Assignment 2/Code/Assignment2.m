% Mahdi Tabatabei
%% Part 0 - Initialization
clc; clear;

% Defining Variables
subjectID = input('Enter the Subject ID: ');
sessionNumber = input('Enter session number: ');
distanceFromScreen = input('Enter your eyes distance from screen (cm): ');

% Save Results
Result = struct;
Result.Trial_Data = struct;
Result.Suject_ID = subjectID;
Result.Session_Number = sessionNumber;
Result.Distance_From_Screen = distanceFromScreen;

% Clear Variables
clear subjectID sessionNumber distanceFromScreen;
%% Part 1 - Fractals and Trials Categorization and Randomization
clc;

% Permuting fractals
fractals_permutation = [ones(12,1); 2.*ones(12,1); 3.*ones(12,1); 4*ones(12,1)];
fractals_permutation = fractals_permutation(randperm(48));

% 4 fractal groups (Perceptual-Good=1, Perceptual-Bad=2, Value-Good=3, Value-Bad=4)
Perceptual_Good = find(fractals_permutation == 1); 
Perceptual_Bad = find(fractals_permutation == 2); 
Value_Good = find(fractals_permutation == 3); 
Value_Bad = find(fractals_permutation == 4); 

% Loading Fractals and assign a number for its group
fractals = cell(48, 2);
for i = 1:48
    if i < 10
        filename = ['Assignment2_fractals/0', num2str(i), '.jpeg'];
    else
        filename = ['Assignment2_fractals/', num2str(i), '.jpeg'];
    end
    fractals{i,1} = fractals_permutation(i);
    fractals{i,2} = imread(filename);
end

% fractals:
% Col 1 = Group Number(Perceptual-Good = 1, Perceptual-Bad = 2, Value-Good = 3, Value-Bad = 4) 
% Col 2 = Fractal's Image

% Permuting trials
init_angle = 0:359;
DS = [3,5,7,9];

% 4 groups (Perceptual-TP=1, Perceptual-TA=2, Value-TP=3, Value-TA=4)
PTP_Permutation = zeros(1440, 2);
PTA_Permutation = zeros(1440, 2);
VTA_Permutation = zeros(1440, 2);
VTP_Permutation = zeros(1440, 2);

% Putting initial angle & DS in permutation
for i = 1:4
    PTP_Permutation(360*(i-1)+1:360*i,1) = DS(i).*ones(360,1);
    PTP_Permutation(360*(i-1)+1:360*i,2) = init_angle';
    PTA_Permutation(360*(i-1)+1:360*i,1) = DS(i).*ones(360,1);
    PTA_Permutation(360*(i-1)+1:360*i,2) = init_angle';
    VTA_Permutation(360*(i-1)+1:360*i,1) = DS(i).*ones(360,1);
    VTA_Permutation(360*(i-1)+1:360*i,2) = init_angle';
    VTP_Permutation(360*(i-1)+1:360*i,1) = DS(i).*ones(360,1);
    VTP_Permutation(360*(i-1)+1:360*i,2) = init_angle';
end

% Randomize the rows
PTP_Permutation = PTP_Permutation(randperm(1440, 36),:);
PTA_Permutation = PTA_Permutation(randperm(1440, 36),:);
VTA_Permutation = VTA_Permutation(randperm(1440, 36),:);
VTP_Permutation = VTP_Permutation(randperm(1440, 36),:);

% To have a 36 elemenets of vector with 3 of each number among 1 to 12
temp = zeros(36,1);
for i = 1:12
    temp(3*(i-1)+1:3*i,1) = i;
end

% Add Good fractal to trial
PTP_Permutation(:,3) = Perceptual_Good(temp(randperm(36)));
VTP_Permutation(:,3) = Value_Good(temp(randperm(36)));

% Add Bad fractal to trial
for i = 1:36 
    index = Perceptual_Bad(randperm(12))';
    PTP_Permutation(i,4:(PTP_Permutation(i,1)+2)) = index(1,1:(PTP_Permutation(i,1)-1));
    index = Value_Bad(randperm(12))';
    VTP_Permutation(i,4:(VTP_Permutation(i,1)+2)) = index(1,1:(VTP_Permutation(i,1)-1));
    index = Perceptual_Bad(randperm(12))';
    PTA_Permutation(i,3:(PTA_Permutation(i,1)+2)) = index(1,1:(PTA_Permutation(i,1)));
    index = Value_Bad(randperm(12))';
    VTA_Permutation(i,3:(VTA_Permutation(i,1)+2)) = index(1,1:(VTA_Permutation(i,1)));
end

% Define Trials matrix
trials = zeros(144,12);
for i = 1:4
    trials(36*(i-1)+1:36*i,1) = i;
end

% Add column to Trials matrix
trials(0*36+1:1*36,2:12) = PTP_Permutation(1:36,:);
trials(1*36+1:2*36,2:12) = PTA_Permutation(1:36,:);
trials(2*36+1:3*36,2:12) = VTP_Permutation(1:36,:);
trials(3*36+1:4*36,2:12) = VTA_Permutation(1:36,:);

% Randomize the rows
trials = trials(randperm(144),:);

% trials:
% Col 1 = Group Number(Perceptual-TP = 1, Perceptual-TA = 2, Value-TP = 3, Value-TA = 4)
% Col 2 = DS
% Col 3 = Inital Angle
% Col 4 to 12 = Fractals Number :zero means we didn't need more fractals beacuse of DS.
% If the corresponding trial is TP, Col 4 indicates a good fractal and the other Cols are bad fractal numbers.

% Clear Variables
clear fractals_permutation;
clear PTP_Permutation VTA_Permutation VTP_Permutation PTA_Permutation;
clear filename init_angle i DS temp index;
clear Value_Bad Value_Good Perceptual_Good Perceptual_Bad;

%% Part 2 - Phsychtoolbox

% number of trials
num_trials = 30; %length(trials(:,1));

% Guide rect & Information box
guideRectShow = input('Do you need guiding rectangles? (Yes = 1, No = 0): ');
infoBoxShow = input('Do you need information box? (Yes = 1, No = 0): ');

% Debug Mode 
PsychDebugWindowConfiguration;

% Opening the Screen
[wPtr, rect] = Screen('OpenWindow', max(Screen('Screens')),0,[]);
ShowCursor;

% Finding width & height
width = rect(3);
height = rect(4);

% Finding center of the screen
xCenter = width/2;
yCenter = height/2;

rng('shuffle'); 
format long

% colors
white = [255 255 255];
red = [255 0 0];
green = [0 255 0];
blue = [0 0 255];
yellow = [255 255 0];

fractal_size = 200;   % width of fractal
pen_width = 5;      % width of guiding rectangle
distance = 380;       % distance of center of fractal from center

mouseDetail = -1.*ones(144,5);    % 5 column because GetMouse has 5 elements (x, y, left, scroll, right)
SetMouse(width/2, height/2);

% Beep Sound
[sound,freq] = audioread('ErrorBeep.wav');
sound = [sound'; sound'];
InitializePsychSound;

% Rewards
rewards = zeros(num_trials, 1);
reject_threshold = 1+randi(3);
counter = 0;

% Features of fractals
fractal_radius = 2;
circle_radius = 9;

button_pressed = cell(num_trials,1);
fractal_names = zeros(num_trials,9);
fractal_position = cell(num_trials,9);
trial_DS = zeros(num_trials,1);
vp_groups = cell(num_trials,1);
target_groups = cell(num_trials,1);
mouse_positions = cell(num_trials,1);

for i = 1:num_trials
    trial = trials(i,:);
    position = zeros(9,4);
    good_index = 0;

    % Blue Fixation Dot, [300, 500] ms
    Screen('FillOval', wPtr, blue, [xCenter-25 yCenter-25 xCenter+25 yCenter+25]);
    Screen('Flip', wPtr);
    fixation_time = 0.2*rand + 0.3;
    WaitSecs(fixation_time);

    % Fixation Off, Fractals Onset, 3 s
    DS = trial(2);
    init_angle = trial(3);
    angle_difference = 360/DS;
    random_fractals = randperm(DS) + 3;

    % Indicating Each Fractal
    for j = 1:DS
        % Making Texture of Fractal
        fractal_texture = Screen('MakeTexture', wPtr, fractals{trial(random_fractals(j)),2});

        % Angle for Finding Position
        Theta = (pi/180)*(init_angle + (j-1)*angle_difference);
        xStart = distance*cos(Theta) + xCenter - fractal_size/2;
        yStart = -distance*sin(Theta) + yCenter - fractal_size/2;
        xEnd = distance*cos(Theta) + xCenter + fractal_size/2;
        yEnd = -distance*sin(Theta) + yCenter + fractal_size/2;
        position(j,:) = [xStart yStart xEnd yEnd];
        fractal_position{i,j} = position(j,:);

        % Show Texture of Fractal
        Screen('DrawTexture', wPtr, fractal_texture, [], position(j,:));

        % TP/TA and if Good Fractal exist
        if (trial(1) == 1 || trial(1) == 3)
            TP = 1;
            if (trial(4) == trial(random_fractals(j))) % Trial is TP and Good Fractal exist.
                good_index = j;
                guide_rect_color = green;
            else                                       % Trial is TP but Good Fractal does'nt exist.
                guide_rect_color = red;
            end
            target_groups{i,1} = 'TP';
        else
            guide_rect_color = red;
            TP = 0;
            target_groups{i,1} = 'TA';
        end

        % Show Rectangles
        if guideRectShow == 1
            Screen('FrameRect', wPtr, guide_rect_color, position(j,:), pen_width);
        end
    end

    % Information Box
    if (i > 1 && infoBoxShow == 1)

        press_info = 'Nothing Press';

        % Find ACCEPT/REJECT Press
        if (mouseDetail(i-1,3) == 1) % Left Click Pressed
            press_info = 'ACCEPT PRESS';
        elseif (mouseDetail(i-1,5) == 1) % Right Click Pressed
            press_info = 'REJECT PRESS';
        end

        % Not Pressing
        if error == 1
            Screen('DrawText',wPtr,'ERROR! You did not press anything!',50,170,[255 255 255]); 
        elseif error == 2
            Screen('DrawText',wPtr,'ERROR! Do not Press on Blank Area!',50,170,[255 255 255]); 
        end

        % Reward
        reward_info = ['REWARD = ',num2str(rewards(i - 1,1))];

        % Value/Perceptual
        if trials(i-1,1) == 3 || trials(i-1,1) == 4 
            trial_info = 'TRIAL = VALUE GROUP     ';
        else
            trial_info = 'TRIAL = PERCEPTUAL GROUP';
        end

        % Draw Box
        Screen('TextFont', wPtr, 'Helvetica');
        Screen('TextSize', wPtr, 24);
        Screen('FrameRect', wPtr, white, [40, 70, 450, 200], pen_width);
        Screen('DrawText', wPtr, press_info, 50, 80, white);
        Screen('DrawText', wPtr, reward_info, 50, 110, white);
        Screen('DrawText', wPtr, trial_info, 50, 140, white); 
    end

    error = 0;
    mouse_button = 0;
    key_button = 0;
    keyIsDown = 0;
    xMouse = 0;
    yMouse = 0;
    prev_x = NaN;
    prev_y = NaN;
    finish_time = GetSecs() + 5;
    start_time = GetSecs();
    SetMouse(width/2, height/2);

    draw = 0;
    while (~mouse_button) & (key_button ~= 32) & (key_button ~= 88) & (finish_time > GetSecs())
        [xMouse, yMouse, mouse_button] = GetMouse();
        [keyIsDown, secs, keyCode] = KbCheck(-1);
        if keyIsDown == 1
            key_button = find(keyCode);
        end

        % Color of Line
        current_time = GetSecs();
        elapsed_time = current_time - start_time;
        t = elapsed_time / 1.5;
        currentColor = (1 - t) * yellow + t * green;

        % Show Line
        if (xMouse ~= prev_x || yMouse ~= prev_y && mod(draw, 2) == 0)
            % Draw a line from previous position to current position
            if (~isnan(prev_x) )
                Screen('FillOval', wPtr, currentColor, [xMouse-2.5, yMouse-2.5, xMouse+2.5, yMouse+2.5]);
            end
            prev_x = xMouse;
            prev_y = yMouse;
            draw = draw + 1;
        end
        Screen('Flip', wPtr, 0, 1);
    end
    
    mouseDetail(i,:) = [xMouse, yMouse, mouse_button];
    indicator = ClickedArea(mouseDetail(i, 1:2), position, good_index, DS);

    if (sum(mouseDetail(i,3:5)) == 0 && keyIsDown == 0)                      % No Press 
        % Error beep + 1.5 s ITI
        error = 1;
        BeepSound(freq, sound)
        WaitSecs(1.5);
        button_pressed{i,1} = 'Not Pressed';
    elseif indicator == 0                                                    % Blank Area
        % Error beep + 1.5 s ITI
        error = 2;
        BeepSound(freq, sound)
        WaitSecs(1.5);
        button_pressed{i,1} = 'Blank Area';
    elseif ((mouseDetail(i,3) == 1 || key_button == 32) && indicator == 1)  % Accept Press (TP/TA) - Bad Choice
        % +1 Reward + 1.5 s ITI
        rewards(i,1) = rewards(i,1) + 1;
        WaitSecs(1.5);
        button_pressed{i,1} = 'Accept';
    elseif ((mouseDetail(i,3) == 1 || key_button == 32) && indicator == 2)  % Accept Press (TP) - Good Choice
        % +3 Reward + 1.5 s ITI
        rewards(i,1) = rewards(i,1) + 3;
        WaitSecs(1.5);
        button_pressed{i,1} = 'Accept';
    elseif ((mouseDetail(i,5) == 1 || key_button == 88) && TP == 1)          % Reject Press, TP
        % 0 Reward + 200 ms ITI
        WaitSecs(0.2);
        button_pressed{i,1} = 'Reject';
    elseif ((mouseDetail(i,5) == 1 || key_button == 88) && TP == 0 ...       % Reject Press, TA, has'nt Reached Threshold 
            && counter ~= reject_threshold)
        % 0 Reward + 200 ms ITI
        counter = counter + 1;
        WaitSecs(0.2);
        button_pressed{i,1} = 'Reject';
    elseif ((mouseDetail(i,5) == 1 || key_button == 88) ...                  % Reject Press, TA, has Reached Threshold 
            && TP == 0 && counter == reject_threshold)
        % +1 Reward + 1.5 s ITI
        rewards(i,1) = rewards(i,1) + 1;
        WaitSecs(1.5);
        counter = 0;
        reject_threshold = 1+randi(3);
        button_pressed{i,1} = 'Reject';
    end

    % Saving Data of each Trial
    fractal_names(i,:) = trial(4:12);
    trial_DS(i,1) = trial(2);
    mouse_positions{i,1} = mouseDetail(i, 1:2);

    if (trial(1) == 4 || trial(1) == 3)
        vp_groups{i,1} = 'Value';
    else
        vp_groups{i,1} = 'Perceptual';
    end
end


% Save data
Result.FractalSizeInDegree = atan(fractal_radius/Result.Distance_From_Screen)*180/pi;
Result.PeripheralCircleDegree = atan(circle_radius/Result.Distance_From_Screen)*180/pi;
Result.ScreenSize = rect;
Result.Trial_Data.Button_Pressed = button_pressed;
Result.Trial_Data.Fractals_Name = fractal_names;
Result.Trial_Data.Fractals_Position = fractal_position;
Result.Trial_Data.DS = trial_DS;
Result.Trial_Data.VP_Group = vp_groups;
Result.Trial_Data.TATP_Group = target_groups;
Result.Trial_Data.Mouse_Position = mouse_positions;

Screen('CloseAll');

% Clear Variables
clear angle_difference blue red green white yellow circle_radius counter prev_x prev_y key_button;
clear distance DS error finish_time fixation_time sound current_time currentColor keyCode;
clear fractal_radius fractal_sizec fractal_texture good_index guide_rect_color secs;
clear pen_width guideRectShow height i indicator infoBoxShow init_angle j mouse_button;
clear mouseDetail num_trials position press_info random_fractals t start_time freq;
clear rect reject_threshold reward_info Theta TP trial trial_info fractal_size keyIsDown;
clear width wPtr xCenter xEnd xMouse xStart yCenter yEnd yMouse yStart draw elapsed_time;
%% Functions

% indicator = (0 -> Blank Area), (1 -> Bad Fractal), (2 -> Good Fractal)
function indicator = ClickedArea(focused_position, fractal_position, good_index, DS)
    fractal_focused = 0 ;
    good_focused = 0;
    
    for i = 1:DS
        if (focused_position(1) > fractal_position(i,1) ...                 % x_clicked > x_start
                && focused_position(1) < fractal_position(i,3) ...          % x_clicked < x_end
                && focused_position(2) > fractal_position(i,2) ...          % y_clicked > y_start
                &&  focused_position(2) < fractal_position(i,4))            % y_clicked > y_end
            fractal_focused = 1;
        end
    end

    if (good_index ~= 0)
        if (focused_position(1) > fractal_position(good_index,1) ...        % x_clicked > x_start
                && focused_position(1) < fractal_position(good_index,3) ... % x_clicked < x_end
                && focused_position(2) > fractal_position(good_index,2) ... % y_clicked > y_start
                && focused_position(2) < fractal_position(good_index,4))    % y_clicked > y_end
            good_focused = 1;
        end
    end

    if fractal_focused == 1 && good_focused == 1
        indicator = 2;
    elseif fractal_focused == 1 && good_focused == 0
        indicator = 1;
    else
        indicator = 0;
    end
end

function BeepSound(freq, sound)
    pahandle = PsychPortAudio('Open', [], [], 0, freq, 2);
    PsychPortAudio('FillBuffer', pahandle, sound);
    PsychPortAudio('Start', pahandle, [], [], 1);
    PsychPortAudio('Close', pahandle);
end
