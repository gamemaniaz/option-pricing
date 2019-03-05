function varargout = project6(varargin)
% PROJECT6 MATLAB code for project6.fig
%      PROJECT6, by itself, creates a new PROJECT6 or raises the existing
%      singleton*.
%
%      H = PROJECT6 returns the handle to a new PROJECT6 or the handle to
%      the existing singleton*.
%
%      PROJECT6('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROJECT6.M with the given input arguments.
%
%      PROJECT6('Property','Value',...) creates a new PROJECT6 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before project6_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to project6_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help project6

% Last Modified by GUIDE v2.5 26-Mar-2017 00:21:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @project6_OpeningFcn, ...
                   'gui_OutputFcn',  @project6_OutputFcn, ...
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


% --- Executes just before project6 is made visible.
function project6_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to project6 (see VARARGIN)

% Choose default command line output for project6
handles.output = hObject;

handles.edit1.String='SBUX';
handles.edit2.String='01/01/2016';
handles.edit3.String='01/01/2017';


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes project6 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = project6_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s=handles.edit1.String;
startDate=handles.edit2.String;
endDate=handles.edit3.String;

yahootable=...
    'http://real-chart.finance.yahoo.com/table.csv';

month_start= month(startDate,'dd/mm/yyyy');  
year_start= year(startDate,'dd/mm/yyyy');
day_start= day(startDate,'dd/mm/yyyy');
month_end=month(endDate,'dd/mm/yyyy');
year_end= year(endDate,'dd/mm/yyyy');
day_end=day(endDate,'dd/mm/yyyy');

% concatenation with input dates 
urlstring= [yahootable...
    '?s=' s...
    '&a=' num2str(month_start-1)...
    '&b=' num2str(day_start)...
    '&c=' num2str(year_start)...
    '&d=' num2str(month_end-1)...
    '&e=' num2str(day_end)...
    '&f=' num2str(year_end)...
    '&g=d'];

% using built in function urlread
res=urlread(urlstring);

% cleaning the data by removing the empty lines 
prices=strread(res,'%s','delimiter','\n');

%extracting the components into columns
[a1,b1,c1,d1,e1,f1,g1]=cellfun(@(x)... 
    strread(x, '%s%f%f%f%f%d%f' ,'delimiter',','),...
    prices(2:end));

%Assignment of relevant values to variables

 closeprices=flipud(e1);
 Dates=flipud(a1);

axes(handles.axes1);

n=length(Dates);
ts1=timeseries(closeprices,1:n);
ts1.Name='Close Price';
ts1.TimeInfo.Units='days';
ts1.TimeInfo.StartDate=startDate;
ts1.TimeInfo.Format= 'dd/mm/yyyy';

ts1.Time=ts1.Time-ts1.Time(1);

plot(ts1)

handles.axes1.XTickLabelRotation=20;
axis tight;

% calculate volatility
%calculate mean price
average_price=mean(closeprices);

%calculates deviation
for i=1:n
    dev(i)=closeprices(i)-average_price;
end
%calculates squared deviations
for i=1:n
    sqdev(1)=0;
    sqdev(i+1)=sqdev(1)+ dev(i).^2;
end
%divide sum by number of observations

SD = (sqdev(n+1)/n)^(0.5);

textLabel = sprintf('SD = %f', SD);
set(handles.text7,'String',SD);

maxprice=max(closeprices);
minprice=min(closeprices);

textLabel=sprintf('maxprice=%f',maxprice);
set(handles.text12,'String',maxprice);

textLabel=sprintf('minprice=%f',minprice);
set(handles.text13,'String',minprice);

function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double




function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double



% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double




% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% Hint: place code in OpeningFcn to populate axes1


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton1.



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Breaking down date inputs

s=handles.edit1.String;
startDate=handles.edit2.String;
ED=handles.edit3.String;
minus50SD1= datetime(year(startDate),month(startDate),day(startDate))-caldays(50);
minus50SD=datestr(minus50SD1,'dd/mm/yyyy');


yahootable=...
    'http://real-chart.finance.yahoo.com/table.csv';

symbol=s;
Amonth_start= month(minus50SD,'dd/mm/yyyy');
Ayear_start= year(minus50SD,'dd/mm/yyyy');
Aday_start= day(minus50SD, 'dd/mm/yyyy');
Amonth_end=month(ED, 'dd/mm/yyyy');
Ayear_end= year(ED, 'dd/mm/yyyy');
Aday_end=day(ED, 'dd/mm/yyyy');

% concatenation with input dates 
Aurlstring= [yahootable...
    '?s=' symbol...
    '&a=' num2str(Amonth_start-1)...
    '&b=' num2str(Aday_start)...
    '&c=' num2str(Ayear_start)...
    '&d=' num2str(Amonth_end-1)...
    '&e=' num2str(Aday_end)...
    '&f=' num2str(Ayear_end)...
    '&g=d'];



% using built in function urlread
Ares=urlread(Aurlstring);

% cleaning the data by removing the empty lines 
Aprices=strread(Ares,'%s','delimiter','\n');

%extracting the components into columns
[a2,b2,c2,d2,e2,f2,g2]=cellfun(@(x)... 
    strread(x, '%s%f%f%f%f%d%f' ,'delimiter',','),...
    Aprices(2:end));

%Assignment of relevant values to variables

 Acloseprices=flipud(e2);
 ADates=flipud(a2);
 
 % calculating 15 day moving average
 n=length(ADates);
 for i=1:n-50
     average15(i)=mean(Acloseprices(i:i+15));
 end
 
 %calculate 50 day moving average
 for i=1:n-50
     average50(i)=mean(Acloseprices(i:i+50));
 end
 
 axes(handles.axes2);
 
 ts1=timeseries(average15,1:n-50);
 
 ts1.Name='Close Price';
 ts1.TimeInfo.Units='days';
 ts1.TimeInfo.StartDate=minus50SD;
 ts1.TimeInfo.Format='dd/mm/yyyy';
 
 ts1.Time=ts1.Time-ts1.Time(1);
 
 plot(ts1)
 
 ts2=timeseries(average50,1:n-50);
 
 ts2.Name='Close Price';
 ts2.TimeInfo.Units='days';
 ts2.TimeInfo.StartDate=minus50SD;
 ts2.TimeInfo.Format='dd/mm/yyyy';

 ts2.Time=ts2.Time-ts2.Time(1);
 
 hold on
 plot(ts2)
 
title('15 Days and 50 Days Moving Average')
ylabel('Moving Average')

handles.axes2.XTickLabelRotation=20;
axis tight;





% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit14_Callback(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit14 as text
%        str2double(get(hObject,'String')) returns contents of edit14 as a double


% --- Executes during object creation, after setting all properties.
function edit14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

model = 1;
S0 = str2double(get(handles.edit7,'String'));
K = str2double(get(handles.edit8,'String'));
r = str2double(get(handles.edit9,'String'));
sig = str2double(get(handles.edit10,'String'));
type = get(handles.edit11,'String');

box1 = str2double(get(handles.edit12,'String'));
box2 = str2double(get(handles.edit13,'String'));
box3 = str2double(get(handles.edit14,'String'));

disp(S0);
disp(K);
disp(r);
disp(sig);
disp(type);
disp(box1);
disp(box2);
disp(box3);

switch model
    case get(handles.radiobutton3, 'Value')
        price = BTM_Eur(S0, K, r, box3, sig, box1, box2, type);
        disp('here1');
    case get(handles.radiobutton4, 'Value')
        price = TTM_Eur(S0, K, r, box3, sig, box1, box2, type);
        disp('here2');
    case get(handles.radiobutton5, 'Value')
        price = MC_Eur(S0, K, r, box3, box1, sig, box2, 1000, type);
        disp('here3');
    case get(handles.radiobutton6, 'Value')
        price = BS_Eur(S0, K, r, box2, sig, box1, type);
        disp(price);
        disp('here4');
    case get(handles.radiobutton7, 'Value')
        Svec = 0 : box1;
        tvec = 0 : (box2 / box1 / 10) : box2;
        price = finDiffExplicit(K, S0, r, sig, Svec, tvec, type);
        disp('here5');
    case get(handles.radiobutton9, 'Value')
        Svec = 0 : box1;
        tvec = 0 : (box2 / box1 / 10) : box2;
        price = finDiffImplicit(K, S0, r, sig, Svec, tvec, type);
        disp('here6');
    case get(handles.radiobutton8, 'Value')
        Svec = 0 : box1;
        tvec = 0 : (box2 / box1 / 10) : box2;
        price = finDiffCN(K, S0, r, sig, Svec, tvec, type);
        disp('here7');
end

set(handles.text22,'String',num2str(price));

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3

set(handles.text19,'String','Dividend Yield');
set(handles.text20,'String','Steps');
set(handles.text21,'String','Time to Maturity');
set(handles.text19,'Visible','On');
set(handles.text20,'Visible','On');
set(handles.text21,'Visible','On');
set(handles.edit12,'Visible','On');
set(handles.edit13,'Visible','On');
set(handles.edit14,'Visible','On');


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4

set(handles.text19,'String','Dividend Yield');
set(handles.text20,'String','Steps');
set(handles.text21,'String','Time to Maturity');
set(handles.text19,'Visible','On');
set(handles.text20,'Visible','On');
set(handles.text21,'Visible','On');
set(handles.edit12,'Visible','On');
set(handles.edit13,'Visible','On');
set(handles.edit14,'Visible','On');


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5

set(handles.text19,'String','Expected Return');
set(handles.text20,'String','Steps');
set(handles.text21,'String','Time to Maturity');
set(handles.text19,'Visible','On');
set(handles.text20,'Visible','On');
set(handles.text21,'Visible','On');
set(handles.edit12,'Visible','On');
set(handles.edit13,'Visible','On');
set(handles.edit14,'Visible','On');

% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6

set(handles.text19,'String','Dividend Yield');
set(handles.text20,'String','Time to Maturity');
set(handles.text19,'Visible','On');
set(handles.text20,'Visible','On');
set(handles.text21,'Visible','Off');
set(handles.edit12,'Visible','On');
set(handles.edit13,'Visible','On');
set(handles.edit14,'Visible','Off');


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7

set(handles.text19,'String','Steps');
set(handles.text20,'String','Time to Maturity');
set(handles.text19,'Visible','On');
set(handles.text20,'Visible','On');
set(handles.text21,'Visible','Off');
set(handles.edit12,'Visible','On');
set(handles.edit13,'Visible','On');
set(handles.edit14,'Visible','Off');


% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8

set(handles.text19,'String','Steps');
set(handles.text20,'String','Time to Maturity');
set(handles.text19,'Visible','On');
set(handles.text20,'Visible','On');
set(handles.text21,'Visible','Off');
set(handles.edit12,'Visible','On');
set(handles.edit13,'Visible','On');
set(handles.edit14,'Visible','Off');


% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9

set(handles.text19,'String','Steps');
set(handles.text20,'String','Time to Maturity');
set(handles.text19,'Visible','On');
set(handles.text20,'Visible','On');
set(handles.text21,'Visible','Off');
set(handles.edit12,'Visible','On');
set(handles.edit13,'Visible','On');
set(handles.edit14,'Visible','Off');

