function all_txt=present_results(results,trial_length,points)

%% Show results to participants

% empty vector shot_bad
shot_bad=NaN*zeros(1,trial_length);

% for loop: shot bad
% purpose: variable for summing up all rightly shot 'bad individuals' 
for i=1:trial_length
if results.weapon_levels(i)=="armed" && results.response(i)=="LeftArrow"
    shot_bad(i)=1
else
    shot_bad(i)=0
end
end

% empty vector shot_good
shot_good=NaN*zeros(1,trial_length);

% for loop: shot bad
% purpose: variable for summing up all falsely shot 'good individuals' 
for i=1:trial_length
if results.weapon_levels(i)=="unarmed" && results.response(i)=="LeftArrow"
    shot_good(i)=1
else
    shot_good(i)=0
end
end

% sum all presented armed and unarmed individuals
sum_armed=sum(double(results.weapon(1:trial_length)));
sum_unarmed=trial_length-sum(double(results.weapon(1:trial_length)));

% percent correct responses
prc_correct=mean(results.correct(1:trial_length))*100

% percent rightly shot 'bad individuals' 
prc_bad=sum(shot_bad)/sum_armed*100;

% percent falsely shot 'good individuals' 
prc_good=sum(shot_good)/sum_unarmed*100;

% percent too slow
prc_slow=mean(results.tooslow(1:trial_length))*100

% text elements for presenting results
bye_txt = 'Vielen Dank für die Teilnahme!';
final_points_string = sprintf('Erreichte Punktzahl: %4.1f\n', points);
correct_string = sprintf('Prozent richtiger Antworten: %4.1f\n', prc_correct);
bad_string = sprintf('Prozent richtigerweise getroffener "Böser": %4.1f\n', prc_bad);
good_string = sprintf('Prozent fälschlicherweise getroffener "Guter": %4.1f\n', prc_good);
tooslow_string = sprintf('Prozent zu langsamer Antworten: %4.1f\n',prc_slow);
key_txt = 'Drücken Sie die LEERTASTE um fortzufahren.';

% Merge text elements into one array
all_txt = [bye_txt '\n\n\n\n\n\n' ...
    final_points_string '\n\n\n\n' ...
    correct_string '\n\n' ...
    bad_string '\n\n' ...
    good_string '\n\n' ...
    tooslow_string '\n\n\n\n\n' , key_txt];