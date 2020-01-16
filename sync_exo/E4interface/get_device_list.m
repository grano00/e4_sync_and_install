function [device_id] = get_device_list(s,server)
%GET_DEVICE_LIST Summary of this function goes here
%   Detailed explanation goes here


%todo - Weak to multiple devices. to improve
connected = false; 
while ~ connected
    fprintf(s,['device_list ' server]);     % Send Command
    R = fscanf(s);    % Receive response
    if contains(R,'R device_list 0')
        disp('no device found, please turn on');
        pause(1);
    else
        connected = true;
        device_id = split(R,'|');
        device_id(1) = [];
        for i = 1:length(device_id)
            t = split(device_id(i));
            device_id(i) = t(2);
            disp(['find device with id ', t(2)]);
        end
        
        
        
    end
end

end

