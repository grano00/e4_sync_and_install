function [answer] = sendmessage(socket,message,display)
%SENDMESSAGE Summary of this function goes here
%   Detailed explanation goes here
fprintf(socket,message);
answer = fscanf(socket);
if display
    disp(message);
    disp(answer);
end
    
end

