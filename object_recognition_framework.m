function varargout = object_recognition_framework(varargin)
% OBJECT_RECOGNITION_FRAMEWORK MATLAB code for object_recognition_framework.fig
%      OBJECT_RECOGNITION_FRAMEWORK, by itself, creates a new OBJECT_RECOGNITION_FRAMEWORK or raises the existing
%      singleton*.
%
%      H = OBJECT_RECOGNITION_FRAMEWORK returns the handle to a new OBJECT_RECOGNITION_FRAMEWORK or the handle to
%      the existing singleton*.
%
%      OBJECT_RECOGNITION_FRAMEWORK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OBJECT_RECOGNITION_FRAMEWORK.M with the given input arguments.
%
%      OBJECT_RECOGNITION_FRAMEWORK('Property','Value',...) creates a new OBJECT_RECOGNITION_FRAMEWORK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before object_recognition_framework_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to object_recognition_framework_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help object_recognition_framework

% Last Modified by GUIDE v2.5 21-Oct-2015 16:50:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @object_recognition_framework_OpeningFcn, ...
                   'gui_OutputFcn',  @object_recognition_framework_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before object_recognition_framework is made visible.
function object_recognition_framework_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to object_recognition_framework (see VARARGIN)

% Choose default command line output for object_recognition_framework
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes object_recognition_framework wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = object_recognition_framework_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_banknoterecog.
function btn_banknoterecog_Callback(hObject, eventdata, handles)
% hObject    handle to btn_banknoterecog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Added by me
currency = cellstr(get(handles.popupmenu_currencies,'String'));
selected_currency = currency{get(hObject,'Value')};
switch selected_currency
    case 'Euro'
        video_recog;
end
delete(handles.figure1);

% --- Executes on button press in btn_prodsrecog.
function btn_prodsrecog_Callback(hObject, eventdata, handles)
% hObject    handle to btn_prodsrecog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% %% Added by me
% product = cellstr(get(handles.popupmenu_prods,'String'));
% selected_product = product{get(hObject,'Value')};
% switch selected_product
%     case 'Food Products'
%         prods_recog;
% end
% delete(handles.figure1);


% --- Executes on button press in btn_start.
function btn_start_Callback(hObject, eventdata, handles)
% hObject    handle to btn_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

path_config;
set(hObject,'Enable', 'off');
handles.common_path = 'object-tree/common/';
first_time = true;
% while(true)
% 
%     if first_time
%         [y,Fs] = audioread(fullfile(handles.common_path, 'italian-audio', 'select.flac'));
%         playerObj = audioplayer(y,Fs);
%         % sound(y,Fs);
%         playblocking(playerObj);
%         first_time = false;
%     else
%         [y,Fs] = audioread(fullfile(handles.common_path, 'italian-audio', 'ripetere.flac'));
%         playerObj = audioplayer(y,Fs);
%         % sound(y,Fs);
%         playblocking(playerObj);
%         first_time = false;
%     end
%     disp('Start speaking.')
%     recObj = audiorecorder(44100, 16, 1,0);
%     recordblocking(recObj, 5);
%     disp('End of Recording.');
%     y = getaudiodata(recObj);
%     % save audio recorded to a temporal file
%     filename = fullfile(handles.common_path, 'temporal', 'temp_record.flac');
%     audiowrite(filename, y, Fs);
%     clear y Fs;
%     % loading file 
%     f = fopen(filename);
%     y = fread(f,Inf,'*uint8');
%     fclose(f);
%     delete(filename);
%     str = urlreadpost('https://www.google.com/speech-api/v2/recognize?output=json&lang=it&key=AIzaSyCMLTmz_hCfDUHMX3OwYpfQSsKbh_j2EGQ', ...
%                       {'file', y});
%     clear y;
%                
%     dat=loadjson(str)
%     condition = true;
%     if length(dat)>1
%         best_translation =  dat{1,2}.result{1,1}.alternative{1,1};        
%         best_translation_str = best_translation.transcript;        
% %         best_translation_confidence = best_translation.confidence;
%         selected_category = RecognizeCategory(best_translation_str);
%         if isempty(selected_category.name)
%             condition=false;
%            
%         end
%     else
%         condition=false;
%     end
% 
%     if condition==true
%         break; 
%     end 
% end
% 
% [y,Fs] = audioread(fullfile(handles.common_path, 'italian-audio', 'corretto.flac'));
% playerObj = audioplayer(y,Fs);
% playblocking(playerObj);
%  
% % % remove, delete, borrar
% FOR MANUAL SELECTION OF CLASSES
 selected_category = RecognizeCategory('lattina'); 
%1- 'euro banconote', 
%2- 'scatola cereale', 
%3- 'lattina', 
%4- 'scatola medicina',
%5- 'deodorante'
%6- 'pomodoro',
%7- 'acqua' 

eurobanknote_parallel_recog(selected_category);
              
% Close current windows
delete(handles.figure1);

function selected_cat = RecognizeCategory(str)

    str = lower(str);
    if (~isempty(strfind(str, 'scatola'))||~isempty(strfind(str, 'scatole'))) && (~isempty(strfind(str, 'cereale')) || ~isempty(strfind(str, 'cereali'))) 
        selected_cat.name = 'cereale'; 
        selected_cat.path = 'object-tree/Supermarket Products/Cereal Box';
        selected_cat.mapping = create_mapping(selected_cat.name);
        selected_cat.num_ranked_images = 3;
        selected_cat.tempDataset = 'gallery';
        valueSet_thresholds_cereals = [1.74, 1.71, 1.58];% FRA=[1.79]; GLASSENSE=[1.76]
        keySet_thresholds_cereals = {'BoF  10k',...
                                     'MBoFQ  20k',...
                                     'FISHER  20k'};
        selected_cat.thresholds = containers.Map(keySet_thresholds_cereals, valueSet_thresholds_cereals);
    elseif (~isempty(strfind(str, 'euro')) || ~isempty(strfind(str, 'euri'))) && (~isempty(strfind(str, 'banconote')) || ~isempty(strfind(str, 'banconoti')))
        selected_cat.name = 'euro'; 
        selected_cat.path = 'object-tree/Currencies/Euro';        
        selected_cat.mapping = create_mapping(selected_cat.name);
        selected_cat.num_ranked_images = 7;
        selected_cat.tempDataset = 'simplebanknotes';
        valueSet_thresholds_euro = [1.90, 1.84, 1.68];% GLASSENSE=[1.89]; PAPER=[1.94, 1.92, 1.72];% FRA=[1.94, 1.84, 1.68];[1.94, 1.84, 1.68]
        keySet_thresholds_euro = {'BoF  10k',...
                                  'MBoFQ  20k',...
                                  'FISHER  20k'};
        selected_cat.thresholds = containers.Map(keySet_thresholds_euro, valueSet_thresholds_euro);
    elseif (~isempty(strfind(str, 'scatola')) || ~isempty(strfind(str, 'scatole'))) && (~isempty(strfind(str, 'medicina')) || ~isempty(strfind(str, 'medicine')))
        selected_cat.name = 'medicina'; 
        selected_cat.path = 'object-tree/Medicines/Medicine Box';        
        selected_cat.mapping = create_mapping(selected_cat.name);
        selected_cat.num_ranked_images = 3;
        selected_cat.tempDataset = 'gallery';
        valueSet_thresholds_euro = [1.81, 1.81, 1.68];% PAPER_CANS=[1.86, 1.81, 1.68]; FRA=[1.825, 1.92, 1.77]; GLASSENSE=[1.81]
        keySet_thresholds_euro = {'BoF  10k',...
                                  'MBoFQ  20k',...
                                  'FISHER  20k'};
       selected_cat.thresholds = containers.Map(keySet_thresholds_euro, valueSet_thresholds_euro);
    elseif (~isempty(strfind(str, 'lattina')) || ~isempty(strfind(str, 'lattine')))
        selected_cat.name = 'lattina'; 
        selected_cat.path = 'object-tree/Supermarket Products/Cans';        
        selected_cat.mapping = create_mapping(selected_cat.name);
        selected_cat.num_ranked_images = 3;
        selected_cat.tempDataset = 'gallery-cans';
        valueSet_thresholds_cans = [1.86, 1.83, 1.68];
        keySet_thresholds_cans = {'BoF  10k',...
                                  'MBoFQ  20k',...
                                  'FISHER  20k'};
        selected_cat.thresholds = containers.Map(keySet_thresholds_cans, valueSet_thresholds_cans);
        selected_cat.skip_classes = [1, 2, 8, 10, 16];
    elseif (~isempty(strfind(str, 'deodorante')) || ~isempty(strfind(str, 'deodoranti')))
        selected_cat.name = 'deodorante'; 
        selected_cat.path = 'object-tree/Supermarket Products/Deodorant Stick';        
        selected_cat.mapping = create_mapping(selected_cat.name);
        selected_cat.num_ranked_images = 3;
        selected_cat.tempDataset = 'gallery-deodorant';
    elseif (~isempty(strfind(str, 'pomodoro')) || ~isempty(strfind(str, 'pomodori')))
        selected_cat.name = 'pomodoro'; 
        selected_cat.path = 'object-tree/Supermarket Products/Tomatos';        
        selected_cat.mapping = create_mapping(selected_cat.name);
        selected_cat.num_ranked_images = 3;
        selected_cat.tempDataset = 'gallery-tomatos';
    elseif (~isempty(strfind(str, 'acqua')) || ~isempty(strfind(str, 'acque')))
        selected_cat.name = 'acqua'; 
        selected_cat.path = 'object-tree/Supermarket Products/Water Bottle';        
        selected_cat.mapping = create_mapping(selected_cat.name);
        selected_cat.num_ranked_images = 3;
        selected_cat.tempDataset = 'gallery-bottles';
    else
        selected_cat.name = '';
        selected_cat.path = '';
        selected_cat.mapping = [];
        selected_cat.num_ranked_images = -1;
    end
    
    
% %     str = lower(str);
% %     if (~isempty(strfind(str, 'scatola'))||~isempty(strfind(str, 'scatole'))) && (~isempty(strfind(str, 'cereale')) || ~isempty(strfind(str, 'cereali'))) 
% %         selected_cat.name = 'cereale'; 
% %         selected_cat.path = 'object-tree/Supermarket Products/Cereal Box';
% %         selected_cat.mapping = create_mapping(selected_cat.name);
% %         selected_cat.num_ranked_images = 3;
% %         selected_cat.tempDataset = 'gallery';
% %         valueSet_thresholds_cereals = [1.74, 1.71, 1.58];% FRA=[1.79];
% %         keySet_thresholds_cereals = {'BoF  10k',...
% %                                      'MBoFQ  20k',...
% %                                      'FISHER  20k'};
% %         selected_cat.thresholds = containers.Map(keySet_thresholds_cereals, valueSet_thresholds_cereals);
% %     elseif (~isempty(strfind(str, 'euro')) || ~isempty(strfind(str, 'euri'))) && (~isempty(strfind(str, 'banconote')) || ~isempty(strfind(str, 'banconoti')))
% %         selected_cat.name = 'euro'; 
% %         selected_cat.path = 'object-tree/Currencies/Euro';        
% %         selected_cat.mapping = create_mapping(selected_cat.name);
% %         selected_cat.num_ranked_images = 7;
% %         selected_cat.tempDataset = 'simplebanknotes';
% %         valueSet_thresholds_euro = [1.94, 1.92, 1.72];% FRA=[1.94, 1.84, 1.68];
% %         keySet_thresholds_euro = {'BoF  10k',...
% %                                   'MBoFQ  20k',...
% %                                   'FISHER  20k'};
% %         selected_cat.thresholds = containers.Map(keySet_thresholds_euro, valueSet_thresholds_euro);
% %     elseif (~isempty(strfind(str, 'scatola')) || ~isempty(strfind(str, 'scatole'))) && (~isempty(strfind(str, 'medicina')) || ~isempty(strfind(str, 'medicina')))
% %         selected_cat.name = 'medicina'; 
% %         selected_cat.path = 'object-tree/Medicines/Medicine Box';        
% %         selected_cat.mapping = create_mapping(selected_cat.name);
% %         selected_cat.num_ranked_images = 3;
% %         selected_cat.tempDataset = 'gallery';
% %         valueSet_thresholds_euro = [1.86, 1.81, 1.68];% FRA=[1.825, 1.92, 1.77];
% %         keySet_thresholds_euro = {'BoF  10k',...
% %                                   'MBoFQ  20k',...
% %                                   'FISHER  20k'};
% %        selected_cat.thresholds = containers.Map(keySet_thresholds_euro, valueSet_thresholds_euro);
% %     elseif (~isempty(strfind(str, 'lattina')) || ~isempty(strfind(str, 'lattine')))
% %         selected_cat.name = 'lattina'; 
% %         selected_cat.path = 'object-tree/Supermarket Products/Cans';        
% %         selected_cat.mapping = create_mapping(selected_cat.name);
% %         selected_cat.num_ranked_images = 3;
% %         selected_cat.tempDataset = 'gallery-cans';
% %         valueSet_thresholds_cans = [1.86, 1.83, 1.68];
% %         keySet_thresholds_cans = {'BoF  10k',...
% %                                   'MBoFQ  20k',...
% %                                   'FISHER  20k'};
% %         selected_cat.thresholds = containers.Map(keySet_thresholds_cans, valueSet_thresholds_cans);
% %         selected_cat.skip_classes = [1, 2, 8, 10, 16];
% %     elseif (~isempty(strfind(str, 'deodorante')) || ~isempty(strfind(str, 'deodoranti')))
% %         selected_cat.name = 'deodorante'; 
% %         selected_cat.path = 'object-tree/Supermarket Products/Deodorant Stick';        
% %         selected_cat.mapping = create_mapping(selected_cat.name);
% %         selected_cat.num_ranked_images = 3;
% %         selected_cat.tempDataset = 'gallery-deodorant';
% %     elseif (~isempty(strfind(str, 'pomodoro')) || ~isempty(strfind(str, 'pomodori')))
% %         selected_cat.name = 'pomodoro'; 
% %         selected_cat.path = 'object-tree/Supermarket Products/Tomatos';        
% %         selected_cat.mapping = create_mapping(selected_cat.name);
% %         selected_cat.num_ranked_images = 3;
% %         selected_cat.tempDataset = 'gallery-tomatos';
% %     elseif (~isempty(strfind(str, 'acqua')) || ~isempty(strfind(str, 'acque')))
% %         selected_cat.name = 'acqua'; 
% %         selected_cat.path = 'object-tree/Supermarket Products/Water Bottle';        
% %         selected_cat.mapping = create_mapping(selected_cat.name);
% %         selected_cat.num_ranked_images = 3;
% %         selected_cat.tempDataset = 'gallery-bottles';
% %     else
% %         selected_cat.name = '';
% %         selected_cat.path = '';
% %         selected_cat.mapping = [];
% %         selected_cat.num_ranked_images = -1;
% %     end