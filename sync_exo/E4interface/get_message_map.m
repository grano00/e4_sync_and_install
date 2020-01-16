function [messagemap] = get_message_map()
%GET_MESSAGE_MAP Summary of this function goes here
%   Detailed explanation goes here

messagemap = struct();

messagemap.list = 'device_list';
messagemap.discover = 'device_discover_list';
messagemap.connect = 'device_connect_btle';
messagemap.gsr_on = 'device_subscribe gsr ON';
messagemap.acc_on = 'device_subscribe acc ON';
messagemap.bvp_on = 'device_subscribe bvp ON';
messagemap.ibi_on = 'device_subscribe ibi ON';
messagemap.tmp_on = 'device_subscribe tmp ON';
messagemap.bat_on = 'device_subscribe bat ON';
messagemap.tag_on = 'device_subscribe tag ON';
messagemap.pause_on = 'device_subscribe gsr ON';





end

