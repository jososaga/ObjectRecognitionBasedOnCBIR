% a=2;
% [y,Fs] = audioread('test.flac');
% sound(y,Fs);

% url = 'https://www.google.com/speech-api/v2/recognize?output=json&lang=en-us&key=AIzaSyCMLTmz_hCfDUHMX3OwYpfQSsKbh_j2EGQ';
% method = 'POST';
% header = http_createHeader('Content-Type','audio/x-flac; rate=44100');
% urlread2(url, method, *body, header, varargin);
% urlConnection.setRequestProperty('Content-Type','audio/x-flac; rate=44100');

f = fopen('test.flac');
d = fread(f,Inf,'*uint8');  % Read in byte stream of MP3 file
fclose(f);
str = urlreadpost('https://www.google.com/speech-api/v2/recognize?output=json&lang=en-us&key=AIzaSyCMLTmz_hCfDUHMX3OwYpfQSsKbh_j2EGQ', ...
          {'file', d});
% str = urlreadpost('https://www.google.com/speech-api/v2/recognize', ...
%           {'output', 'json', 'lang', 'en-us', 'key', 'AIzaSyCMLTmz_hCfDUHMX3OwYpfQSsKbh_j2EGQ', 'file', d});