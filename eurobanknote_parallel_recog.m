function varargout = eurobanknote_parallel_recog(varargin)
% EUROBANKNOTE_PARALLEL_RECOG MATLAB code for eurobanknote_parallel_recog.fig
%      EUROBANKNOTE_PARALLEL_RECOG, by itself, creates a new EUROBANKNOTE_PARALLEL_RECOG or raises the existing
%      singleton*.
%
%      H = EUROBANKNOTE_PARALLEL_RECOG returns the handle to a new EUROBANKNOTE_PARALLEL_RECOG or the handle to
%      the existing singleton*.
%
%      EUROBANKNOTE_PARALLEL_RECOG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EUROBANKNOTE_PARALLEL_RECOG.M with the given input arguments.
%
%      EUROBANKNOTE_PARALLEL_RECOG('Property','Value',...) creates a new EUROBANKNOTE_PARALLEL_RECOG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eurobanknote_parallel_recog_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eurobanknote_parallel_recog_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eurobanknote_parallel_recog

% Last Modified by GUIDE v2.5 21-Oct-2015 10:23:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eurobanknote_parallel_recog_OpeningFcn, ...
                   'gui_OutputFcn',  @eurobanknote_parallel_recog_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_tate, varargiSn{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before eurobanknote_parallel_recog is made visible.
function eurobanknote_parallel_recog_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eurobanknote_parallel_recog (see VARARGIN)

% Choose default command line output for eurobanknote_parallel_recog
handles.output = hObject;

%% Added by me 
set(handles.snapshot_btn,'Enable', 'off');
set(handles.stop_btn,'Enable', 'off');

selected_cat = varargin{1};
str_detected = sprintf('Detected %s', selected_cat.name);
str_classes = sprintf('Classes of %s', selected_cat.name);
set(handles.detected_panel, 'Title', str_detected);
set(handles.banknotes_panel, 'Title', str_classes);

all_cat_keys = selected_cat.mapping.keys;
unique_cat = unique(selected_cat.mapping.values);

handles.categories_path = selected_cat.path;
handles.common_path = 'object-tree/common/';
handles.class_mapping = selected_cat.mapping;
handles.num_ranked_images = selected_cat.num_ranked_images;
handles.tempDataset = selected_cat.tempDataset;
if isfield(selected_cat,'thresholds')
    handles.thresholds = selected_cat.thresholds;
end
if isfield(selected_cat,'skip_classes')
    handles.skip_classes = selected_cat.skip_classes;
end

% Loading predifined images
handles.I_none = imread(fullfile(handles.common_path, 'images', 'not_image.png'));
Imgs = cell(length(unique_cat));
Imgs_handles = cell(length(unique_cat));
hdls_classfigure = {'bank_den1' 'bank_den2' 'bank_den3' 'bank_den4' 'bank_den5'};
for i=1:min(length(unique_cat),length(hdls_classfigure))
    handle_currentClass = findobj(handles.figure1, 'Tag', hdls_classfigure{i});
    axes(handle_currentClass);
    
    % Image thumbnail
    Imgs{i} = imread(fullfile(selected_cat.path, 'media', [unique_cat{i}, '_thumbnail.jpg']));
    Imgs_handles{i} = imshow(Imgs{i});
    set(Imgs_handles{i}, 'Parent', handle_currentClass);
%     % Image to show the result
%     handles.Imgs{i} = imread(fullfil(selected_cat.path, '/media/', unique_cat{i}));
end

Imgs = cell(length(all_cat_keys));
% Loading all reference images
for i=1:length(all_cat_keys)
    handles.Imgs{i} = imread(fullfile(selected_cat.path, 'media', [selected_cat.mapping(all_cat_keys{i}), '.jpg']));
end
handles.class_image_mapping = containers.Map(selected_cat.mapping.keys, handles.Imgs);

clear Imgs Imgs_handles;


%% Added by me
descriptors = cellstr(get(handles.descriptor_menu,'String'));
selected_descriptor = descriptors{get(handles.descriptor_menu,'Value')};

value = -1;
if isfield(handles,'thresholds') && isKey(handles.thresholds, selected_descriptor)
    value = handles.thresholds(selected_descriptor);
else
    value = 1.94;% Default value
end
set(handles.sim_slider, 'Value', value);
set(handles.currentsim_edit, 'String', num2str(value));

% Update handles structure
guidata(hObject, handles);

% % % % OJO
% % % % % % start_btn_Callback(hObject, eventdata, handles);

% UIWAIT makes eurobanknote_parallel_recog wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = eurobanknote_parallel_recog_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in start_btn.
function start_btn_Callback(hObject, eventdata, handles)
% hObject    handle to start_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Added by me
info = imaqhwinfo('macvideo');
% info.DeviceInfo
% info.DeviceInfo.SupportedFormats
if isempty(info.DeviceIDs)
    mode = struct('WindowStyle','modal',... 
   'Interpreter','tex');
    errorstring = 'There is not a connected camera';
    h = errordlg(errorstring, 'Loading Camera Error', mode);
end

activated_phone = get(handles.phonecam_checkbox, 'Value');
device_id = info.DeviceIDs{1};
if activated_phone
    if length(info.DeviceIDs)>1
        device_id = 1;% info.DeviceIDs{length(info.DeviceIDs)};
    elseif length(info.DeviceIDs)==1 %% There is only one connected camera
        device_id = info.DeviceIDs{1};
    else
        mode = struct('WindowStyle','modal',... 
       'Interpreter','tex');
        errorstring = 'There is not a connected camera';
        h = errordlg(errorstring, 'Loading Camera Error', mode);
    end
end
vid_resolution = info.DeviceInfo(device_id).SupportedFormats{1};
if sum(strcmp(info.DeviceInfo(device_id).SupportedFormats, 'MJPG_640x480'))>=1 % 'YUY2_640x480'
    vid_resolution = 'MJPG_640x480'; % 'YUY2_640x480'
end
handles.vid = videoinput('macvideo', device_id, vid_resolution); % 'YUY2_640x480'
set(handles.vid,'ReturnedColorSpace', 'grayscale');

axes(handles.webcam_figure);
handles.vidRes = get(handles.vid, 'VideoResolution');
handles.hImage = image(zeros(handles.vidRes(2), handles.vidRes(1)));
preview(handles.vid, handles.hImage);
set(handles.snapshot_btn,'Enable', 'on');
set(handles.stop_btn,'Enable', 'on');
set(handles.start_btn,'Enable', 'off');
% Setting unavailable the ranking parameters
set(handles.descriptor_menu, 'Enable', 'off');
set(handles.sim_slider, 'Enable', 'off');
set(handles.currentsim_edit, 'Enable', 'off');
handles.isvideo = true;

%Timer: after how many seconds I will call back the same function 
handles.TimerData=timer('TimerFcn', {@FrameProcessing, handles}, 'Period', 1 , 'ExecutionMode', 'fixedRate', 'BusyMode', 'drop');
start(handles.TimerData);

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in stop_btn.
function stop_btn_Callback(hObject, eventdata, handles)
% hObject    handle to stop_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
% %% Added by me
set(handles.start_btn,'Enable', 'on');
set(handles.snapshot_btn,'Enable', 'off');
set(handles.stop_btn,'Enable', 'off');
set(handles.exec_time, 'String', '0.0');
set(handles.min_distance, 'String', '0.0');
set(handles.fea_time, 'String', '0.0');
set(handles.desc_time, 'String', '0.0');
set(handles.rank_time, 'String', '0.0');
set(handles.max_distance, 'String', '0.0');
set(handles.fea_numb, 'String', '0.0');
% Setting available the ranking parameters
set(handles.descriptor_menu, 'Enable', 'on');
set(handles.sim_slider, 'Enable', 'on');
set(handles.currentsim_edit, 'Enable', 'on');

% closepreview;
if handles.isvideo
    stoppreview(handles.vid);
    stop(handles.TimerData);
    delete(handles.TimerData);
end

% clear persistent variables
clear functions;

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in snapshot_btn.
function snapshot_btn_Callback(hObject, eventdata, handles)
% hObject    handle to snapshot_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Added by me
persistent handlesPlot;
% persistent I_none I5 I10 I20 I50;
persistent nBases dictionaryPath method dimensions idf_path ...
           gmmPath tempDataset nConfigSpace encoding_method ...
           codingDictionary dimFea query_vector classes_reference ...
           reference_norm num_ranked_images IDF_training ...
           means covariances priors pyramid ...
           dic_filename means_filename covariances_filename priors_filename idf_filename reference_desc_filename;
       
persistent methodOld nBasesOld;

if ~isfield(handles, 'method')% || isempty(handlesPlot)
    method = 'bof';
    nBases = 10000;
    
    methodOld = 'incial';
    nBasesOld = -1;
    
    num_ranked_images = handles.num_ranked_images;
    tempDataset = handles.tempDataset;
else
    method = handles.method;
    nBases = handles.nBases;
end

if (~strcmp(method, methodOld)) || (nBases~=nBasesOld)
   
    %% Parameters
    dic_filename = ['clust_', tempDataset, '_k' int2str(nBases) '.fvecs'];
    dictionaryPath = fullfile(handles.categories_path, 'dictionaries', dic_filename);
    dimensions = 64;
    gmmPath = fullfile(handles.categories_path, 'gmm');
    nConfigSpace = 1;
    encoding_method = 'hard';
    
    %% Loading Dictionaries
    codingDictionary = fvecs_read(dictionaryPath);
    
    %% Setting descriptor dimension
    dimFea = 0;
    switch method
        case 'bofxq'
            dimFea = nBases*4;
        case 'vlad'
            dimFea = nBases*dimensions;
        case 'fisher'
            means_filename = ['means_', tempDataset, '_k', int2str(nBases), '.mat'];
            covariances_filename = ['covariances_', tempDataset, '_k', int2str(nBases), '.mat'];
            priors_filename = ['priors_', tempDataset, '_k', int2str(nBases), '.mat'];
            load(fullfile(gmmPath, means_filename));
            load(fullfile(gmmPath, covariances_filename));
            load(fullfile(gmmPath, priors_filename));
            dimFea = nBases*dimensions*2;
        case 'bof'
            idf_filename = ['IDF_', tempDataset, '_' int2str(nBases) '.fvecs'];
            idf_path = fullfile(handles.categories_path, idf_filename);
            %% Loading IDF training
            IDF_training = fvecs_read(idf_path);
            dimFea = nBases;
        case 'spm'
            pyramid = [1, 2, 4];
            dimFea = sum((nBases)*(nConfigSpace)*pyramid.^2);
    end;
    query_vector = zeros(dimFea, 1, 'single');
    
     % Reference dataset
    load(fullfile(handles.categories_path, 'classes_reference.mat'));
    reference_desc_filename = ['reference_norm_', method, '_', num2str(dimFea), '.mat'];
    load(fullfile(handles.categories_path, reference_desc_filename));
        
    methodOld = method;
    nBasesOld = nBases;
end

if handles.isvideo
    % IM = getdata(handles.vid,1,'uint8');
    IM = getsnapshot(handles.vid);
else
    IM = handles.I_loadedimage;
end

if ndims(IM) == 3,
    IM = im2double(rgb2gray(IM));
else
    IM = im2double(IM);
end;

maxImSize = 640;
[im_h, im_w] = size(IM);

if max(im_h, im_w) > maxImSize,
    IM = imresize(IM, maxImSize/max(im_h, im_w), 'bicubic');
end;

% ouput_path = 'C:\Users\joan\Desktop\SampleImages-Blindfolded\new\';
% file_path = [ouput_path, '2-2.jpg'];
% imwrite(IM, file_path);

process_time = cputime;

% Extracting SURF features from current frame
[im_h, im_w] = size(IM);
points = detectSURFFeatures(IM);
[features, valid_points] = extractFeatures(IM, points);
imageFeatures = features';
locs = [double(valid_points.Location(:, 1)) double(valid_points.Location(:, 2))]';%double(valid_points.Location(:, 1:2))';

temp_time = cputime;
feaExt_time = temp_time - process_time;

%% Computing Image Descriptor
if ~isempty(imageFeatures)
    switch encoding_method
        case 'hard'
            [idx, dis] = yael_nn (single(codingDictionary), single(imageFeatures), 1); %LLC_coding_appr(codingDictionary', imageFeatures',knn)';
            coordI = [1:size(imageFeatures, 2)];
            coordJ = double(idx);
            values = ones(1, size(imageFeatures, 2), 'double');
            codes = sparse(coordI, coordJ, values, size(imageFeatures, 2), size(codingDictionary, 2));
    end

    %% Computing image descriptor of the current image with corresponding method
    switch method
        case 'bofxq'
            border_filter = zeros(1, size(locs,2)) + 1;
            area = true;
            query_vector(:, 1) = vwdist_repr(codes', locs, codingDictionary, area, border_filter); % vwdist_repr(codes', locs, codingDictionary, area, border_filter); % vwdist_repr_upd(codes', locs, codingDictionary, area, border_filter, feaSet.height_patches, feaSet.width_patches);
        case 'vlad'
            query_vector(:, 1) = vl_vlad(double(imageFeatures), double(codingDictionary), full(codes'));
        case 'fisher'
            query_vector(:, 1) = vl_fisher(imageFeatures, means, covariances, priors);
        case 'bof'
            query_vector(:, 1) = full(sum(codes));
            if sum(query_vector)~=0
                query_vector = query_vector/sum(query_vector);
            end;
        case 'spm'
            poolingDictionary = ones(nBases, 1);
            pool_method = 'sum';
            normFact_pool_method = 2;
            norm_factor = 2;
            query_vector(:, 1) = boureau_pooling(codes', locs, pyramid, im_w, im_h, poolingDictionary, pool_method, normFact_pool_method, norm_factor); % boureau_pooling(codes', locs, pyramid, im_w, im_h, poolingDictionary, 2);
    end;            
end;

%% Postprocessing analysis in case is needed
switch method
    case 'bof'
        query_vector(:, 1) = (query_vector(:, 1)).*(IDF_training');
end;

temp_temp_time = cputime;
description_time = temp_temp_time - temp_time;

%% Compute Ranking
query_vector_norm = sign(query_vector).*abs(query_vector).^(0.1);
query_vector_norm = yael_vecs_normalize(query_vector_norm);
[ranking, dis] = yael_nn (reference_norm, query_vector_norm, num_ranked_images, 2);

training_class_array = zeros(1, num_ranked_images);
for j=1:num_ranked_images
    training_index = ranking(j, 1);
    training_class = classes_reference{training_index}.class;
    training_class_array(j) = training_class;
%     if ~(isfield(handles,'skip_classes') && ismember(training_class, handles.skip_classes))
%         training_class_array(j) = training_class;
%     else
%         j = j - 1;
%     end
end
majoritary_class = mode(training_class_array);

ranking_time = cputime - temp_temp_time;
process_time = feaExt_time + description_time + ranking_time;

set(handles.exec_time, 'String', num2str(process_time));
set(handles.fea_time, 'String', num2str(feaExt_time));
set(handles.desc_time, 'String', num2str(description_time));
set(handles.rank_time, 'String', num2str(ranking_time));
set(handles.min_distance, 'String', num2str(dis(1)));
set(handles.max_distance, 'String', num2str(dis(num_ranked_images)));
set(handles.fea_numb, 'String', num2str(valid_points.Count));

I_final = [];

minSim_value = get(handles.sim_slider, 'Value');

% if dis(num_ranked_images) > minSim_value
%     majoritary_class = -1;
% end

if majoritary_class ~= -1
    I_final = handles.class_image_mapping(majoritary_class);
    class_audio_file = fullfile(handles.categories_path, 'media', [handles.class_mapping(majoritary_class), '.flac']);
    if exist(class_audio_file, 'file')
        [y,Fs] = audioread(class_audio_file);
        sound(y,Fs);
    end
end

if isempty(handlesPlot)|| ~isvalid(handlesPlot)
    axes(handles.detected_figure);
    handlesPlot = imshow(I_final);
    set(handlesPlot, 'Parent', handles.detected_figure);
else
    set(handlesPlot,'CData', I_final);
end

%% For ROC curves (Thresholds selection)
if get(handles.nobanknote_checkbox, 'Value')
    final_class_temp = sprintf('%02d', 0);
else
    final_class_temp = sprintf('%02d', majoritary_class);
end
ouput_path = 'D:\Dropbox\Unige-Research\1-Object Recognition Demo App\Demo-code\ObjectRecognitionFramework_1.2\object-tree\Currencies\Euro\output\TEMP_JOAN\';
siftfname = struct2cell (dir(fullfile(ouput_path, '*.jpg')));
siftfname = siftfname(1, :);
nimg = size (siftfname, 2);
num_img = sprintf('%03d', nimg+1);
file_path = [ouput_path, num_img, final_class_temp, '.jpg'];
imwrite(IM, file_path);

% --- Executes on selection change in descriptor_menu.
function descriptor_menu_Callback(hObject, eventdata, handles)
% hObject    handle to descriptor_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns descriptor_menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from descriptor_menu

%% Added by me
descriptors = cellstr(get(hObject,'String'));
selected_descriptor = descriptors{get(hObject,'Value')};
switch selected_descriptor
    case 'BoF  10k'
        handles.method = 'bof';
        handles.nBases = 10000;
    case 'BoF  20k'
        handles.method = 'bof';
        handles.nBases = 20000;
    case 'MBoFQ  10k'
        handles.method = 'bofxq';
        handles.nBases = 2500;
    case 'MBoFQ  20k'
        handles.method = 'bofxq';
        handles.nBases = 5000;
    case 'VLAD  10k'
        handles.method = 'vlad';
        handles.nBases = 150;
    case 'VLAD  20k'
        handles.method = 'vlad';
        handles.nBases = 300;
    case 'FISHER  10k'
        handles.method = 'fisher';
        handles.nBases = 80;
    case 'FISHER  20k'
        handles.method = 'fisher';
        handles.nBases = 150;
    case 'SPM  10k'
        handles.method = 'spm';
        handles.nBases = 500;
    case 'SPM  20k'
        handles.method = 'spm';
        handles.nBases = 1000;
end

value = -1;
if isfield(handles,'thresholds') && isKey(handles.thresholds, selected_descriptor)
    value = handles.thresholds(selected_descriptor);
else
    value = 1.94;% Default value
end
set(handles.sim_slider, 'Value', value);
set(handles.currentsim_edit, 'String', num2str(value));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function descriptor_menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to descriptor_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function sim_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sim_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function currentsim_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to currentsim_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function sim_slider_Callback(hObject, eventdata, handles)
% hObject    handle to sim_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%% Added by me
current_value = get(hObject,'Value');
current_value = sprintf('%0.3f', current_value);
set(handles.currentsim_edit, 'String', num2str(current_value));

function currentsim_edit_Callback(hObject, eventdata, handles)
% hObject    handle to currentsim_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of currentsim_edit as text
%        str2double(get(hObject,'String')) returns contents of currentsim_edit as a double

%% Added by me
current_value = get(hObject,'String');
% Exclude characters, which are accepted by sscanf:
S(ismember(current_value, '-+eEgG')) = ' ';
% Convert to one number and back to a string:
current_value2 = sprintf('%0.3f', sscanf(current_value, '%g', 1));
set(hObject, 'String', current_value2);
% Perhaps a small warning in WARNDLG or inside the GUI:
if ~all(ismember(S, '.1234567890'))
    warndlg('Input must be numerical');
else
    set(handles.sim_slider, 'Value', str2num(current_value2));
end

% --- Executes on button press in loadimage_btn.
function loadimage_btn_Callback(hObject, eventdata, handles)
% hObject    handle to loadimage_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Added by me
[FileName, PathName] = uigetfile('*.jpg','Select the image file');
if ~isequal(FileName,0)
    handles.isvideo = false;
%     guidata(hObject, handles);
    stop_btn_Callback(hObject, eventdata, handles);
    handles.I_loadedimage = imread(fullfile(PathName, FileName));
    axes(handles.webcam_figure);
    imshow(handles.I_loadedimage);
    set(handles.snapshot_btn, 'Enable', 'on');
end

% Update handles structure
guidata(hObject, handles);

% --- % This function is called by the timer to process one video frame
function FrameProcessing(obj, event, handles)

persistent lastDetectedClass;
persistent idx_lastDetectedClass;
persistent max_DetectedClass;
persistent timelastDetectedClass;

if isempty(lastDetectedClass)
    max_DetectedClass = 1;
    if isempty(lastDetectedClass)
    lastDetectedClass = zeros(1, max_DetectedClass)-1;
    end
    if isempty(idx_lastDetectedClass)
        idx_lastDetectedClass = 1;
    end
end

persistent handlesPlot;
persistent nBases dictionaryPath method dimensions idf_path ...
           gmmPath tempDataset nConfigSpace encoding_method ...
           codingDictionary dimFea query_vector classes_reference ...
           reference_norm num_ranked_images IDF_training ...
           means covariances priors pyramid ...
           dic_filename means_filename covariances_filename priors_filename idf_filename reference_desc_filename;
       
persistent methodOld nBasesOld;

    if ~isfield(handles, 'method')% || isempty(handlesPlot)
        method = 'bof';
        nBases = 10000;

        methodOld = 'incial';
        nBasesOld = -1;
        
        num_ranked_images = handles.num_ranked_images;
        tempDataset = handles.tempDataset;
    else
        method = handles.method;
        nBases = handles.nBases;
    end

    if (~strcmp(method, methodOld)) || (nBases~=nBasesOld)

        %% Parameters
        dic_filename = ['clust_', tempDataset, '_k' int2str(nBases) '.fvecs'];
        dictionaryPath = fullfile(handles.categories_path, 'dictionaries', dic_filename);
        dimensions = 64;
        gmmPath = fullfile(handles.categories_path, 'gmm');
        nConfigSpace = 1;
        encoding_method = 'hard';

        %% Loading Dictionaries
        codingDictionary = fvecs_read(dictionaryPath);

        %% Setting descriptor dimension
        dimFea = 0;
        switch method
            case 'bofxq'
                dimFea = nBases*4;
            case 'vlad'
                dimFea = nBases*dimensions;
            case 'fisher'
                means_filename = ['means_', tempDataset, '_k', int2str(nBases), '.mat'];
                covariances_filename = ['covariances_', tempDataset, '_k', int2str(nBases), '.mat'];
                priors_filename = ['priors_', tempDataset, '_k', int2str(nBases), '.mat'];
                load(fullfile(gmmPath, means_filename));
                load(fullfile(gmmPath, covariances_filename));
                load(fullfile(gmmPath, priors_filename));
                dimFea = nBases*dimensions*2;
            case 'bof'
                idf_filename = ['IDF_', tempDataset, '_' int2str(nBases) '.fvecs'];
                idf_path = fullfile(handles.categories_path, idf_filename);
                %% Loading IDF training
                IDF_training = fvecs_read(idf_path);
                dimFea = nBases;
            case 'spm'
                pyramid = [1, 2, 4];
                dimFea = sum((nBases)*(nConfigSpace)*pyramid.^2);
        end;
        query_vector = zeros(dimFea, 1, 'single');

         % Reference dataset
        load(fullfile(handles.categories_path, 'classes_reference.mat'));
        reference_desc_filename = ['reference_norm_', method, '_', num2str(dimFea), '.mat'];
        load(fullfile(handles.categories_path, reference_desc_filename));

        methodOld = method;
        nBasesOld = nBases;
    end

    if handles.isvideo
        % IM = getdata(handles.vid,1,'uint8');
        IM = getsnapshot(handles.vid);
    else
        IM = handles.I_loadedimage;
    end
    
%     IM_rgb = IM;
    
    % IM = imread('C:\Users\Joan\Desktop\IMG_20150410_161742.jpg');
    if ndims(IM) == 3,
        IM = im2double(rgb2gray(IM));
    else
        IM = im2double(IM);
    end;

    maxImSize = 1182;
    [im_h, im_w] = size(IM);

    if max(im_h, im_w) > maxImSize,
        IM = imresize(IM, maxImSize/max(im_h, im_w), 'bicubic');
    end;

    %process_time = cputime;
    tic;
    
    % Extracting SURF features from current frame
    [im_h, im_w] = size(IM);
    points = detectSURFFeatures(IM);
    [features, valid_points] = extractFeatures(IM, points);
    imageFeatures = features';
    locs = [double(valid_points.Location(:, 1)) double(valid_points.Location(:, 2))]';%double(valid_points.Location(:, 1:2))';

    %temp_time = cputime;
    feaExt_time = toc;%temp_time - process_time;
    tic;
    %% Computing Image Descriptor
    if ~isempty(imageFeatures)
        switch encoding_method
            case 'hard'
                [idx, dis] = yael_nn (single(codingDictionary), single(imageFeatures), 1); %LLC_coding_appr(codingDictionary', imageFeatures',knn)';
                coordI = [1:size(imageFeatures, 2)];
                coordJ = double(idx);
                values = ones(1, size(imageFeatures, 2), 'double');
                codes = sparse(coordI, coordJ, values, size(imageFeatures, 2), size(codingDictionary, 2));
        end

        %% Computing image descriptor of the current image with corresponding method
        switch method
            case 'bofxq'
                border_filter = zeros(1, size(locs,2)) + 1;
                area = true;
                query_vector(:, 1) = vwdist_repr(codes', locs, codingDictionary, area, border_filter); % vwdist_repr(codes', locs, codingDictionary, area, border_filter); % vwdist_repr_upd(codes', locs, codingDictionary, area, border_filter, feaSet.height_patches, feaSet.width_patches);
            case 'vlad'
                query_vector(:, 1) = vl_vlad(double(imageFeatures), double(codingDictionary), full(codes'));
            case 'fisher'
                query_vector(:, 1) = vl_fisher(imageFeatures, means, covariances, priors);
            case 'bof'
                query_vector(:, 1) = full(sum(codes));
                if sum(query_vector)~=0
                    query_vector = query_vector/sum(query_vector);
                end;
            case 'spm'
                poolingDictionary = ones(nBases, 1);
                pool_method = 'sum';
                normFact_pool_method = 2;
                norm_factor = 2;
                query_vector(:, 1) = boureau_pooling(codes', locs, pyramid, im_w, im_h, poolingDictionary, pool_method, normFact_pool_method, norm_factor); % boureau_pooling(codes', locs, pyramid, im_w, im_h, poolingDictionary, 2);
        end;            
    end;

    %% Postprocessing analysis in case is needed
    switch method
        case 'bof'
            query_vector(:, 1) = (query_vector(:, 1)).*(IDF_training');
    end;

    %temp_temp_time = cputime;
    description_time = toc;%temp_temp_time - temp_time;
    tic;

    %% Compute Ranking
    query_vector_norm = sign(query_vector).*abs(query_vector).^(0.1);
    query_vector_norm = yael_vecs_normalize(query_vector_norm);
    %% My implementation of KNN
    [ranking, dis] = yael_nn (reference_norm, query_vector_norm, num_ranked_images, 2);
    training_class_array = zeros(1, num_ranked_images);
    for j=1:num_ranked_images
        training_index = ranking(j, 1);
        training_class = classes_reference{training_index}.class;
        training_class_array(j) = training_class;
    end
    majoritary_class = mode(training_class_array);
%     %% Using matlab KNN
%     sample = query_vector_norm';
%     training = reference_norm';
%     group = zeros(size(training, 1), 1);
%     for j=1:size(group, 1)
%         group(j) = classes_reference{j}.class;
%     end
%     majoritary_class = knnclassify(sample, training, group, num_ranked_images);

    ranking_time = toc;%cputime - temp_temp_time;
    process_time = feaExt_time + description_time + ranking_time;

    set(handles.exec_time, 'String', num2str(process_time));
    set(handles.fea_time, 'String', num2str(feaExt_time));
    set(handles.desc_time, 'String', num2str(description_time));
    set(handles.rank_time, 'String', num2str(ranking_time));
    set(handles.min_distance, 'String', num2str(dis(1)));
    set(handles.max_distance, 'String', num2str(dis(num_ranked_images)));
    set(handles.fea_numb, 'String', num2str(valid_points.Count));

    set(handles.text27, 'String', method);

    I_final = [];

    minSim_value = get(handles.sim_slider, 'Value');
    if dis(num_ranked_images) >= minSim_value || isnan(dis(num_ranked_images))
        majoritary_class = -1;
    end
    
    %% here starts
    lastDetectedClass(idx_lastDetectedClass) = majoritary_class;
    current_time = cputime;
    if isempty(timelastDetectedClass)
        timelastDetectedClass = 0;
    end
    time_to_wait = 10;
    
    if mode(lastDetectedClass) ~= -1
        I_final = handles.class_image_mapping(mode(lastDetectedClass));
        %if ((current_time-timelastDetectedClass)>time_to_wait)% || isempty(lastDetectedClass) || lastDetectedClass~=majoritary_class
            class_audio_file = fullfile(handles.categories_path, 'media', [handles.class_mapping(mode(lastDetectedClass)), '.flac']);
            if exist(class_audio_file, 'file')
                [y,Fs] = audioread(class_audio_file);
                sound(y,Fs);
            end
            %lastDetectedClass=majoritary_class;
            timelastDetectedClass = current_time;
        %end
    else
        I_final = handles.I_none;        
        %lastDetectedClass = majoritary_class;
        timelastDetectedClass = current_time;
    end
    
    if isempty(handlesPlot) || ~isvalid(handlesPlot)
        axes(handles.detected_figure);
        handlesPlot = imshow(I_final);
        set(handlesPlot, 'Parent', handles.detected_figure);
    else
        set(handlesPlot,'CData', I_final);
    end
    
    idx_lastDetectedClass = idx_lastDetectedClass+1;
    if idx_lastDetectedClass == max_DetectedClass+1
        lastDetectedClass = zeros(1, max_DetectedClass)-1;
        idx_lastDetectedClass = 1;
    end


% %% For ROC curves (Thresholds selection)
% majoritary_class = 11;
% trans = 's';
% if get(handles.nobanknote_checkbox, 'Value')
%     final_class_temp = sprintf('%02d', 0);
% else
%     final_class_temp = sprintf('%02d', majoritary_class);
% end
% ouput_path = ['D:\object-tree\euro\' final_class_temp '\' trans '\day1\'];
% siftfname = struct2cell (dir(fullfile(ouput_path, '*.jpg')));
% siftfname = siftfname(1, :);
% nimg = size (siftfname, 2);
% num_img = sprintf('%03d', nimg+1+500);
% file_path = [ouput_path, num_img, final_class_temp, '.jpg'];
% imwrite(IM_rgb, file_path);
% 
% %% ROC curves GLASSENSE
% % majoritary_class = 14;
% % if get(handles.nobanknote_checkbox, 'Value')
% %     final_class_temp = sprintf('%02d', 0);
% % else
% %     final_class_temp = sprintf('%02d', majoritary_class);
% % end
% % ouput_path = 'D:\Dropbox\Unige-Research\1-Object Recognition Demo App\Demo-code\ObjectRecognitionFramework_1.2\object-tree\Currencies\Euro\output\New folder\';
% % siftfname = struct2cell (dir(fullfile(ouput_path, '*.jpg')));
% % siftfname = siftfname(1, :);
% % nimg = size (siftfname, 2);
% % num_img = sprintf('%03d', nimg+1);
% % file_path = [ouput_path, num_img, final_class_temp, '.jpg'];
% % imwrite(IM, file_path);
% 
% 
% %%     %% OLD    
% % %     current_time = cputime;
% % %     if isempty(timelastDetectedClass)
% % %         timelastDetectedClass = 0;
% % %     end
% % %     time_to_wait = 10;
% % %     
% % %     if majoritary_class ~= -1
% % %         I_final = handles.class_image_mapping(majoritary_class);
% % %         if ((current_time-timelastDetectedClass)>time_to_wait) || isempty(lastDetectedClass) || lastDetectedClass~=majoritary_class
% % %             class_audio_file = fullfile(handles.categories_path, 'media', [handles.class_mapping(majoritary_class), '.flac']);
% % %             if exist(class_audio_file, 'file')
% % %                 [y,Fs] = audioread(class_audio_file);
% % %                 sound(y,Fs);
% % %             end
% % %             lastDetectedClass=majoritary_class;
% % %             timelastDetectedClass = current_time;
% % %         end
% % %     else
% % %         I_final = handles.I_none;        
% % %         lastDetectedClass = majoritary_class;
% % %         timelastDetectedClass = current_time;
% % %     end
% % %     
% % %     if isempty(handlesPlot) || ~isvalid(handlesPlot)
% % %         axes(handles.detected_figure);
% % %         handlesPlot = imshow(I_final);
% % %         set(handlesPlot, 'Parent', handles.detected_figure);
% % %     else
% % %         set(handlesPlot,'CData', I_final);
% % %     end

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

t = timerfindall;
if ~isempty(t)
  stop(t);
  delete(t);
end

% Hint: delete(hObject) closes the figure
delete(hObject);
