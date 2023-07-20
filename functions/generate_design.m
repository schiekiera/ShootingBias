function design = generate_design(id)
%%
id=123;
weapon = 0:1;
ethnicity = 0:1;
stimuli_number = 1:20;


% create minimal orthogonal design (all combinations of factors)
design_small = CombVec(weapon, ethnicity, stimuli_number)';

 n=4;
 x=(1:20);
 image=repmat(x,1,n);
 image=sort(image);
 image=string(image)';
 image_bg=image;

 i1=(1:4:80)';
 i2=i1+1';
 i3=i1+2';
 i4=i1+3';

% image
for i=i1
  image(i1)=image(i1)+"a.jpg";
end

for i=i2
  image(i2)=image(i2)+"b.jpg";
end

for i=i3
  image(i3)=image(i3)+"c.jpg";
end

for i=i4
  image(i4)=image(i4)+"d.jpg";
end

% image_bg

for i=i1
  image_bg(i1)=image_bg(i1)+".jpg";
end

for i=i2
  image_bg(i2)=image_bg(i2)+".jpg";
end

for i=i3
  image_bg(i3)=image_bg(i3)+".jpg";
end

for i=i4
  image_bg(i4)=image_bg(i4)+".jpg";
end


% levels
weapon_levels = strings(length(design_small),1);
for i=1:length(design_small)
    if design_small(i,1)==1
        weapon_levels(i)="armed"
    else
        weapon_levels(i)="unarmed"
    end
end

ethnicity_levels = strings(length(design_small),1);
for i=1:length(design_small)
    if design_small(i,2)==1
        ethnicity_levels(i)="arab"
    else
        ethnicity_levels(i)="caucasian"
    end
end

expected_response = strings(length(design_small),1);
for i=1:length(design_small)
    if design_small(i,1)==1
        expected_response(i)="LeftArrow"
    else
        expected_response(i)="RightArrow"
    end
end


mat=[design_small,weapon_levels,ethnicity_levels,image,image_bg,expected_response]

mat_x = mat(randperm(size(mat, 1)), :)

design=array2table(mat_x,'VariableNames',{'weapon','ethnicity','stimulus_number','weapon_levels','ethnicity_levels','image','image_bg','expected_response'})

outfile_design_name = ['material/Design_Essien_2017_' num2str(id), '.dat'];
writetable(design, outfile_design_name,'Delimiter','\t','Encoding','UTF-8');
