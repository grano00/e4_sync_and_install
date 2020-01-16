addpath('E4interface');

%% Varibales
%server = '159.149.133.28';
server = '127.0.0.1';
port = 28000;
serverPath = "D:\Program Files (x86)\Empatica\EmpaticaBLEServer\EmpaticaBLEServer.exe &";

prompt = "how many sync? [integer]: ";
number = input(prompt);



%% START THE CLIENT and get the connected device

s = tcpip(server, port, 'NetworkRole', 'client','InputBufferSize',1024);
fopen(s); %% TODO fare check loop non aperto
device_id = get_device_list(s,server);
fclose(s);

n_row = length(device_id) * number;
local_time = zeros(n_row,1);
e4_time = local_time;
type = local_time;
device_name = cell(n_row,1);

%% Create the socket cells and connect to the devices
sockets = cell(length(device_id),1);
for i = 1:length(device_id)
    sockets{i,1} = tcpip(server, port, 'NetworkRole', 'client','InputBufferSize',1024);
    fopen(sockets{i});
    sendmessage(sockets{i},['device_connect ', device_id{i}],true);
    sendmessage(sockets{i},'device_subscribe tag ON',true);
end

disp('click the device buttons');
parfor i = 1:length(device_id)
    exit = false;
    while (~exit)
        try
         fopen(sockets{i});
        catch
        end
        r = fscanf(sockets{i})
        if (contains(r,'E4_Tag'))
            r = strrep(r,',','.');
            data = split(r);
            %disp('press for a short time the device button');
            %tag = [tag; str2num(data{3})];
            e4_time(i,1) = str2num(data{2});
            getdata = datetime('now','Format','yyyy-MM-dd HH:mm:ss.SSS');
            local_time(i,1) = posixtime(getdata);
            device_name(i) = device_id{i};
            exit = true;
        else
           disp(['press tag button on dev ',device_id{i}]);
           disp(['a' r]);
        end
    end
end



T = table(tag,local_time,e4_time,device_name);
kill_streamingserver = 'taskkill /f /im EmpaticaBLEServer.exe';
system(kill_streamingserver);
kill_streamingserver = 'taskkill /f /im cmd.exe';
system(kill_streamingserver);

filename = strcat(str,'_',datestr(datetime('now','Format','yyyy-MM-dd HH:mm:ss.SSS')),'.mat');
filename = strrep(filename,':','-');

save(filename,'T');

disp("5 - quando appare la luce verde spegni e accendi nuovamente il dispositivo (pressione media, 3 sec circa)");
disp("6 - aspetta 60 sec. che la luce verde lampeggi. Dopodichè attendere la fine della luce rossa");
disp("7 - quando ogni luce si spegne avvia la sessione sperimentale")
% disp('boot the device again, wait 60 sec of green led and some sec of red blinking');
% disp('start the experiment');

