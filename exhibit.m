clc %%clears the command window
clear %%clears any varaibles
set(gcf, 'Position',get(0, 'Screensize')); %%sets gcf for the screens full size
hFig = gcf;  %%sets hFig Variable (fit to screen)
hAx = gca;  %%sets hAx variable (fit to screen)
set(hFig, 'units','normalized','outerposition', [0 0 1 1]);  %%continues to configure display to be full screen
set(hAx, 'Unit', 'normalized', 'Position', [0 0 1 1]); %%continues to configure display to be full screen
set(hFig, 'menubar','none'); %%continues to configure display to be full screen
set(hFig, 'NumberTitle','off'); %%continues to configure display to be full screen
set(gca, 'XTick',[]); %%continues to configure display to be full screen
set(gca, 'YTick',[]); %%continues to configure display to be full screen
a = arduino('COM5','UNO', 'Libraries', 'Ultrasonic'); %%creates arduino with ultrasonic library
sensor = ultrasonic(a,'D4','D3'); %%creates an ultrasonic distance sensor
AIN1 = 'D13'; %%motor direction pin one 
AIN2 = 'D12'; %%motor direction pin two
PWMA = 'D11'; %%motor speed pin
b1 = 'D5'; %%sets a pin for button 1
b2 = 'D6'; %%sets a pin for button 2
b3 = 'D7'; %%sets a pin for button 3
out = true; %%sets out to true so while loops activate
bye = false; %%sets bye to false so code is not skipped, if bye true, restart display
path = 0; %%path chosen by user action (determines injury)
choice1 = 0; %%the first button pressed in treatment
choice2 = 0; %%the second button pressed in treatment
score = 0; %%the number of correct treatments
i = 0; %%variable to count motion sensor time
timeMotor = 1; %%time for motor to increment one on progress bar
while(true)
    writeDigitalPin(a,AIN1, 0) %%set the motor to one direction
    writeDigitalPin(a,AIN2 ,1) 
    i = 0; %%reset dist sensor timer
    motor = 0; %%reset motor progress
    bye = false; %%makes sure bye is false at start
    score = 0; %%reset score from last user
    path = 0; %%reset path from last user
    out = true; %%makes sure to enter while loop
    imshow('Welcome Screen.jpg'); %%displays welcome
    while(out) %%loops until out is false
        %%keeps welcome screen up until a user arrives
        if(readDigitalPin(a,b1) == 0) %%if button one is pressed
            out = false; %%set out to false
        elseif(readDigitalPin(a,b2) == 0) %%if button two is pressed
            out = false; %%set out to false
        elseif(readDigitalPin(a,b3) == 0) %%if button three is pressed
            out = false; %%set out to false
        elseif(readDistance(sensor) < 1) %%if a person is by the exhibit
            pause(.1); %%wait for a bit
            i = i+1; %%add to tracker
        elseif(readDistance(sensor) > 1) %%if noone is there
            i = 0; %%reset counter
        end
        if(i >= 4) %%if someone by exhibit for a while
            out = false; %%set out to false
        end
    end
    i = 0; %%resets counter
    pause(1); %%pauses so screen is shown for a bit
    out = true; %%sets ou tback to true
    imshow('Action Screen.jpg'); %%displays screen for action
    pause(0.5); %%pause to prevent random button presses
    while(~bye && out) %%while game not reset and out is true, loops until button is pressed or person leaves
        if(readDigitalPin(a,b1) == 0) %%if button one is pressed
            path = 1; %%sets injury path to 1
            out = false; %%sets out to false
            writePWMVoltage(a,PWMA,2); %%starts motor 
            pause(timeMotor); %%waits for increment
            writePWMVoltage(a,PWMA,0); %%stops motor
            motor = motor+1; %%adds to motor activity tracker
        elseif(readDigitalPin(a,b2) == 0) %%if button two is pressed
            path = 2; %%sets injury path to 2
            out = false; %%sets out to false
            writePWMVoltage(a,PWMA,2); %%starts motor 
            pause(timeMotor); %%waits for increment
            writePWMVoltage(a,PWMA,0); %%stops motor
            motor = motor+1; %%adds to motor activity tracker
        elseif(readDigitalPin(a,b3) == 0) %%if button three is pressed
            path = 3; %%sets injur path to 3
            out = false; %%sets out to false
            writePWMVoltage(a,PWMA,2); %%starts motor 
            pause(timeMotor); %%waits for increment
            writePWMVoltage(a,PWMA,0); %%stops motor
            motor = motor+1; %%adds to motor activity tracker
        elseif(readDistance(sensor) > 1) %%if noone is there
            pause(.1); %%wait for a bit
            i = i+1; %%adds to tracker
        elseif(readDistance(sensor) < 1) %%if a person is by the exhibit
            i = 0; %%resets tracker
        end
        if(i >= 100) %%if some time has passed without anyone
            bye = true; %%sets bye to true (resets code)
            break; %%breaks from while loop
        end
    end
    i = 0; %%resets tracker
    out = true; %%sets out to true
    if(bye)%%skips if bye is true (person gone)
        
    elseif(path == 1) %%if they have injury 1
        imshow('Knee0.jpg'); %%display first knee injury screen
        pause(0.5); %%wait for a bit to prevent random button press
        while(~bye && out) %%loop until out is false or bye is true
            if(readDigitalPin(a,b1) == 0) %%if button one is pressed
                choice1 = 1; %%first treatment is option  one
                writePWMVoltage(a,PWMA,2); %%starts motor 
                pause(timeMotor); %%waits for increment
                writePWMVoltage(a,PWMA,0); %%stops motor
                motor = motor+1; %%adds to motor activity tracker
                imshow('Knee1.jpg'); %%display scrren where option 1 chosen
                pause(0.5); %%pause to prevent random button press
                while(~bye && out) %%loop until out is false or bye is true
                    if(readDigitalPin(a,b1) == 0) %%if button one is pressed
                        choice2 = 1; %%treatment 2 is option 1
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDigitalPin(a,b2) == 0) %%if button two is pressed
                        choice2 = 2; %%treatment 2 is option 2
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDigitalPin(a,b3) == 0) %%if button three is pressed
                        choice2 = 3; %%treatment 2 is option 3
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDistance(sensor) > 1) %%if noone is there
                        pause(.1); %%wait for a bit %%wait for a bit
                        i = i+1; %%add to tracker
                    elseif(readDistance(sensor) < 1) %%if a person is by the exhibit
                        i = 0; %%resets tracker
                    end
                    if(i >= 100) %%if some time has passed without anyone
                        bye = true; %%sets bye to true, resets code
                        break;%%exits loop
                    end
                end
                i = 0; %%resets tracker
            elseif(readDigitalPin(a,b2) == 0) %%if button two is pressed
                choice1 = 2; %%first treatment is option two
                writePWMVoltage(a,PWMA,2); %%starts motor 
                pause(timeMotor); %%waits for increment
                writePWMVoltage(a,PWMA,0); %%stops motor
                motor = motor+1; %%adds to motor activity tracker
                imshow('Knee2.jpg'); %%display scrren where option 2 chosen
                pause(0.5); %%pause to prevent random button press
                while(~bye && out) %%loop while out is true and bye is false
                    if(readDigitalPin(a,b1) == 0) %%if button one is pressed
                        choice2 = 1; %%treatment 2 is option 1
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDigitalPin(a,b2) == 0) %%if button two is pressed
                        choice2 = 2; %%treatment 2 is option 2
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDigitalPin(a,b3) == 0) %%if button three is pressed
                        choice2 = 3; %%treatment 2 is option 3
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDistance(sensor) > 1) %%if noone is there
                        pause(.1); %%wait for a bit %%wait for a bit
                        i = i+1; %%add to tracker
                    elseif(readDistance(sensor) < 1) %%if a person is by the exhibit
                        i = 0; %%resets tracker
                    end
                    if(i >= 100) %%if some time has passed without anyone
                        bye = true; %%sets bye to true (resets code)
                        break; %%breaks out of loop
                    end
                end
                i = 0; %%resets tracker
            elseif(readDigitalPin(a,b3) == 0) %%if button three is pressed
                choice1 = 3; %%first treatment is option three
                writePWMVoltage(a,PWMA,2); %%starts motor 
                pause(timeMotor); %%waits for increment
                writePWMVoltage(a,PWMA,0); %%stops motor
                motor = motor+1; %%adds to motor activity tracker
                imshow('Knee3.jpg'); %%display scrren where option 3 chosen
                pause(0.5); %%pause for a bit to prevent random button press
                while(~bye && out) %%while bye is false and out is true
                    if(readDigitalPin(a,b1) == 0) %%if button one is pressed
                        choice2 = 1; %%treatment 2 is option 1
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDigitalPin(a,b2) == 0) %%if button two is pressed
                        choice2 = 2; %%treatment 2 is option 2
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDigitalPin(a,b3) == 0) %%if button three is pressed
                        choice2 = 3; %%treatment 2 is option 3
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDistance(sensor) > 1) %%if noone is there
                        pause(.1); %%wait for a bit %%wait for a bit
                        i = i+1; %%add to tracker
                    elseif(readDistance(sensor) < 1) %%if a person is by the exhibit
                        i = 0; %%resets tracker
                    end
                    if(i >= 100) %%if some time has passed without anyone
                        bye = true; %%sets bye to true (resets code)
                        break; %%breaks out of while loop
                    end
                end
            elseif(readDistance(sensor) > 1) %%if noone is there
                pause(.1); %%wait for a bit %%wait for a bit
                i = i+1; %%add to tracker
            elseif(readDistance(sensor) < 1) %%if a person is by the exhibit
                i = 0; %%resets tracker
            end
            if(i >= 100) %%if some time has passed without anyone
                bye = true; %%sets bye to true (resets code)
                break; %%breaks out of while loop
            end
        end
        i = 0; %%resets tracker
    elseif(path == 2) %%if they have injury 2
        imshow('Arm0.jpg'); %%show initial arm injury screen
        pause(0.5); %%pause for a bit to prevent random button press
        while(~bye && out) %%while bye is false and out is true
            if(readDigitalPin(a,b1) == 0) %%if button one is pressed
                choice1 = 1; %%first treatment is option  one
                writePWMVoltage(a,PWMA,2); %%starts motor 
                pause(timeMotor); %%waits for increment
                writePWMVoltage(a,PWMA,0); %%stops motor
                motor = motor+1; %%adds to motor activity tracker
                imshow('Arm1.jpg'); %%show arm screen if option 1 is chosen
                pause(0.5); %%pause for a bit to prevent random button press
                while(~bye && out) %%while bye is false and out is true
                    if(readDigitalPin(a,b1) == 0) %%if button one is pressed
                        choice2 = 1; %%treatment 2 is option 1
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDigitalPin(a,b2) == 0) %%if button two is pressed
                        choice2 = 2; %%treatment 2 is option 2
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDigitalPin(a,b3) == 0) %%if button three is pressed
                        choice2 = 3; %%treatment 2 is option 3
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDistance(sensor) > 1) %%if noone is there
                        pause(.1); %%wait for a bit %%wait for a bit
                        i = i+1; %%add to tracker
                    elseif(readDistance(sensor) < 1) %%if a person is by the exhibit
                        i = 0; %%resets tracker
                    end
                    if(i >= 100) %%if some time has passed without anyone
                        bye = true; %%sets bye to true (resets code)
                        break; %%breaks out of while loop
                    end
                end
                i = 0; %%resets tracker
            elseif(readDigitalPin(a,b2) == 0) %%if button two is pressed
                choice1 = 2; %%first treatment is option two
                writePWMVoltage(a,PWMA,2); %%starts motor 
                pause(timeMotor); %%waits for increment
                writePWMVoltage(a,PWMA,0); %%stops motor
                motor = motor+1; %%adds to motor activity tracker
                imshow('Arm2.jpg'); %%display scrren where option 2 chosen
                pause(0.5); %%pause for a bit to prevent random button press
                while(~bye && out) %%while bye is false and out is true
                    if(readDigitalPin(a,b1) == 0) %%if button one is pressed
                        choice2 = 1; %%treatment 2 is option 1
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDigitalPin(a,b2) == 0) %%if button two is pressed
                        choice2 = 2; %%treatment 2 is option 2
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDigitalPin(a,b3) == 0) %%if button three is pressed
                        choice2 = 3; %%treatment 2 is option 3
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDistance(sensor) > 1) %%if noone is there
                        pause(.1); %%wait for a bit %%wait for a bit
                        i = i+1; %%add to tracker
                    elseif(readDistance(sensor) < 1) %%if a person is by the exhibit
                        i = 0; %%resets tracker
                    end
                    if(i >= 100) %%if some time has passed without anyone
                        bye = true; %%sets bye to true (resets code)
                        break; %%breaks out of while loop
                    end
                end
                i = 0; %%resets tracker
            elseif(readDigitalPin(a,b3) == 0) %%if button three is pressed
                choice1 = 3; %%first treatment is option three
                writePWMVoltage(a,PWMA,2); %%starts motor 
                pause(timeMotor); %%waits for increment
                writePWMVoltage(a,PWMA,0); %%stops motor
                motor = motor+1; %%adds to motor activity tracker
                imshow('Arm3.jpg'); %%display scrren where option 3 chosen
                pause(0.5); %%pause for a bit to prevent random button press
                while(~bye && out) %%while bye is false and out is true
                    if(readDigitalPin(a,b1) == 0) %%if button one is pressed
                        choice2 = 1; %%treatment 2 is option 1
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDigitalPin(a,b2) == 0) %%if button two is pressed
                        choice2 = 2; %%treatment 2 is option 2
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDigitalPin(a,b3) == 0) %%if button three is pressed
                        choice2 = 3; %%treatment 2 is option 3
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDistance(sensor) > 1) %%if noone is there
                        pause(.1); %%wait for a bit %%wait for a bit
                        i = i+1; %%add to tracker
                    elseif(readDistance(sensor) < 1) %%if a person is by the exhibit
                        i = 0; %%resets tracker
                    end
                    if(i >= 100) %%if some time has passed without anyone
                        bye = true; %%sets bye to true (resets code)
                        break; %%breaks out of while loop
                    end
                end
                i = 0; %%resets tracker
            elseif(readDistance(sensor) > 1) %%if noone is there
                pause(.1); %%wait for a bit
                i = i+1; %%add to tracker
            elseif(readDistance(sensor) < 1) %%if a person is by the exhibit
                i = 0; %%resets tracker
            end
            if(i >= 100) %%if some time has passed without anyone
                bye = true; %%sets bye to true (resets code)
                break; %%breaks out of while loop
            end
        end
        i = 0; %%resets tracker
    elseif(path == 3) %%if they have injury 3
        imshow('Hamstring0.jpg'); %%shows initial hamstring injury screen
        pause(0.5); %%pause for a bit to prevent random button press
        while(~bye && out) %%while bye is false and out is true
            if(readDigitalPin(a,b1) == 0) %%if button one is pressed
                choice1 = 1; %%first treatment is option  one
                writePWMVoltage(a,PWMA,2); %%starts motor 
                pause(timeMotor); %%waits for increment
                writePWMVoltage(a,PWMA,0); %%stops motor
                motor = motor+1; %%adds to motor activity tracker
                imshow('Hamstring1.jpg'); %%shows screen if treatment option 1 is selected
                pause(0.5); %%pause for a bit to prevent random button press
                while(~bye && out) %%while bye is false and out is true
                    if(readDigitalPin(a,b1) == 0) %%if button one is pressed
                        choice2 = 1; %%treatment 2 is option 1
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDigitalPin(a,b2) == 0) %%if button two is pressed
                        choice2 = 2; %%treatment 2 is option 2
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDigitalPin(a,b3) == 0) %%if button three is pressed
                        choice2 = 3; %%treatment 2 is option 3
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDistance(sensor) > 1) %%if noone is there
                        pause(.1); %%wait for a bit
                        i = i+1; %%add to tracker
                    elseif(readDistance(sensor) < 1) %%if a person is by the exhibit
                        i = 0; %%resets tracker
                    end
                    if(i >= 100) %%if some time has passed without anyone
                        bye = true; %%sets bye to true (resets code)
                        break; %%breaks out of while loop
                    end
                end
                i = 0; %%resets tracker
            elseif(readDigitalPin(a,b2) == 0) %%if button two is pressed
                choice1 = 2; %%first treatment is option two
                writePWMVoltage(a,PWMA,2); %%starts motor 
                pause(timeMotor); %%waits for increment
                writePWMVoltage(a,PWMA,0); %%stops motor
                motor = motor+1; %%adds to motor activity tracker
                imshow('Hamstring2.jpg'); %%display scrren where option 2 chosen
                pause(0.5); %%pause for a bit to prevent random button press
                while(~bye && out) %%while bye is false and out is true
                    if(readDigitalPin(a,b1) == 0) %%if button one is pressed
                        choice2 = 1; %%treatment 2 is option 1
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDigitalPin(a,b2) == 0) %%if button two is pressed
                        choice2 = 2; %%treatment 2 is option 2
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDigitalPin(a,b3) == 0) %%if button three is pressed
                        choice2 = 3; %%treatment 2 is option 3
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDistance(sensor) > 1) %%if noone is there
                        pause(.1); %%wait for a bit
                        i = i+1; %%add to tracker
                    elseif(readDistance(sensor) < 1) %%if a person is by the exhibit
                        i = 0; %%resets tracker
                    end
                    if(i >= 100) %%if some time has passed without anyone
                        bye = true; %%sets bye to true (resets code)
                        break; %%breaks out of while loop
                    end
                end
                i = 0; %%resets tracker
            elseif(readDigitalPin(a,b3) == 0) %%if button three is pressed
                choice1 = 3; %%first treatment is option three
                writePWMVoltage(a,PWMA,2); %%starts motor 
                pause(timeMotor); %%waits for increment
                writePWMVoltage(a,PWMA,0); %%stops motor
                motor = motor+1; %%adds to motor activity tracker
                imshow('Hamstring3.jpg'); %%display scrren where option 3 chosen
                pause(0.5); %%pause for a bit to prevent random button press
                while(~bye && out) %%while bye is false and out is true
                    if(readDigitalPin(a,b1) == 0) %%if button one is pressed
                        choice2 = 1; %%treatment 2 is option 1
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDigitalPin(a,b2) == 0) %%if button two is pressed
                        choice2 = 2; %%treatment 2 is option 2
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDigitalPin(a,b3) == 0) %%if button three is pressed
                        choice2 = 3; %%treatment 2 is option 3
                        out = false; %%sets out to false
                        writePWMVoltage(a,PWMA,2); %%starts motor 
                        pause(timeMotor); %%waits for increment
                        writePWMVoltage(a,PWMA,0); %%stops motor
                        motor = motor+1; %%adds to motor activity tracker
                    elseif(readDistance(sensor) > 1) %%if noone is there
                        pause(.1); %%wait for a bit
                        i = i+1; %%add to tracker
                    elseif(readDistance(sensor) < 1) %%if a person is by the exhibit
                        i = 0; %%resets tracker
                    end
                    if(i >= 100) %%if some time has passed without anyone
                        bye = true; %%sets bye to true (resets code)
                        break; %%breaks out of while loop
                    end
                end
                i = 0; %%resets tracker
            elseif(readDistance(sensor) > 1) %%if noone is there
                pause(.1); %%wait for a bit
                i = i+1; %%add to tracker
            elseif(readDistance(sensor) < 1) %%if a person is by the exhibit
                i = 0; %%resets tracker
            end
            if(i >= 100) %%if some time has passed without anyone
                bye = true; %%sets bye to true (resets code)
                break; %%breaks out of while loop
            end
        end
        i = 0; %%resets tracker
    end
    out = true; %%sets out to true
    if(path == 1) %%if they have injury 1
        if(choice1 == 2) %%treatment 1 = 2
            if(choice2 == 3) %%treatment 2 = 3
                score = 2; %%score 2 if they chose 2 and 3
            else
                score = 1; %%score 1 if only 2 chosen first
            end
        elseif(choice1 == 3) %%treatment 1 = 3
            if(choice2 == 2) %%treatment 2 = 2
                score = 2; %%score 2 if they chose 2 and 3
            else
                score = 1; %%score 2 if only 3 chosen first
            end
        elseif(choice2 == 2 || choice2 == 3) %%if two or three chosen second
            score = 1; %%score of 1
        end
    elseif(path == 2) %%if they have injury 2
        if(choice1 == 3) %%treatment 1 = 3
            if(choice2 == 3)%%treatment 2 = 3
                score = 2; %%score 2 if they chose 3 both times
            else
                score = 1; %%score 1 if only chose 3 first
            end
        else
            if(choice1 == choice2) %%if they chose the same both times (not 3)
                score = 1; %%score 1
            elseif(choice2 == 3) %%if choice 1 not 3 but choice 2 is
                score = 1; %%score 1
            end
        end
    elseif(path == 3) %%if they have injury 3
        if(choice1 == 1) %%treatment 1 = 1
            if(choice2 == 2) %%treatment 2 = 2
                score = 2; %%score 2 if 1 and 2 chosen
            else
                score = 1; %%score 1 if only 1 chosen first
            end
        elseif(choice1 == 2)%%treatment 1 = 2
            if(choice2 == 1)%%treatment 2 = 1
                score = 2; %%score 2 if 1 and 2 chosen
            else
                score = 1;%%score 1 if only 2 chosen first
            end
        elseif(choice2 == 2 || choice2 == 1) %%if choice 1 was wrong but choice 2 is either 2 or 1
            score = 1; %%score one if only second is correct
        end
    end
    if(~bye && score == 2)%%if not reset and score is two
        imshow('ResilianceHigh.jpg'); %%display high score result
        pause(4); %%pause for them to read
    elseif(~bye && score == 1)
        imshow('ResilienceMedium.jpg'); %%display medium score result
        pause(4); %%pause for them to read
    elseif(~bye && score == 0)
        imshow('ResilienceLow.jpg'); %%display low score result
        pause(4); %%pause for them to read
    end
    if(~bye && path == 1) %%if not skipping and injury 1
        imshow('SolutionKnee.jpg'); %%display injury 1 solution
    elseif(~bye && path == 2) %%if not skipping and injury 2
        imshow('SolutionArm.jpg'); %%display injury 2 solution
    elseif(~bye && path == 3) %%if not skipping and injury 3
        imshow('SolutionHamstring.jpg'); %%display injury 3 solution
    end
    while(~bye && out) %%while bye is false and out is true
        if(readDigitalPin(a,b2) == 0) %%if button two is pressed (replay)
            out = false; %%sets out to false
        elseif(readDigitalPin(a,b1) == 0) %%if button one is pressed (no replay)        
            imshow('EndScreen.jpg'); %%display game over screen
            out = false; %%sets out to false
            pause(4); %%pause to read/user to leave
        elseif(readDigitalPin(a,b3) == 0) %%if button three is pressed (no replay)
            imshow('EndScreen.jpg'); %%display game over screen
            out = false; %%sets out to false
            pause(4); %%pause to read/user to leave
        elseif(readDistance(sensor) > 1) %%if noone is there
            pause(.1); %%wait for a bit
            i = i+1; %%add to tracker
        elseif(readDistance(sensor) < 1) %%if a person is by the exhibit
            i = 0; %%resets tracker
        end
        if(i >= 100) %%if some time has passed without anyone
            bye = true; %%sets bye to true (resets code)
            break; %%breaks out of while loop
        end
    end
    writeDigitalPin(a,AIN1, 1) %%switches direction of motor
    writeDigitalPin(a,AIN2 ,0) 
    writePWMVoltage(a,PWMA,2); %%starts motor 
    pause(timeMotor*motor); %%runs motor for same total time is run in other direction
    writePWMVoltage(a,PWMA,0); %%stops motor
end