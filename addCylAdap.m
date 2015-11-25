function addCylAdap( hObject )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
model = guidata(hObject);

% SET DEFAULT VALUES
model.guiCylAdapWidth = 54/2; % mm
model.guiCylAdapHeight = 0; % mm
guiXCircle = 0; % mm
guiYCircle = 0; % mm
lastXCircle = 0; % mm
lastYCircle = 0; % mm
theta = model.angleStep:model.angleStep:360; % degrees
orgData = model.data;

% % SAVE DATA
% guidata(hObject);

% CALL SLIDER UI
slider()
    function slider()
        hSlider = figure;
        axis off;
        name = 'Cylindrical adapter alignment';
        set(hSlider,'Resize','off');
        set(hSlider,'color',[0.192156862745098 0.188235294117647 0.188235294117647]);
        set(hSlider,'name',name);
        set(hSlider,'NumberTitle','off');
        set(hSlider,'MenuBar','none');
        set(hSlider,'ToolBar','none');
        set(hSlider,'Position',[2738 631 329 201]);
        
        % CYLINDRICAL ADAPTER HEIGHT
        hCycAdapHeight = uicontrol('style','text','units',...
            'pixel','position',[15 170 110 20],...
            'string','Adapter (mm): height');
        
        % CYLINDRICAL ADAPTER HEIGHT INPUT
        hCycAdapHeightInput = uicontrol('style','edit','units',...
            'pixel','position',[130 170 20 20],...
            'string','0',...
            'Callback',@heightCallBack);
        
        % CYLINDRICAL ADAPTER WIDTH
        hCycAdapWidth = uicontrol('style','text','units',...
            'pixel','position',[155 170 40 20],...
            'string','radius');
        
        % CYLINDRICAL ADAPTER WIDTH INPUT
        hCycAdapWidthInput = uicontrol('style','edit','units',...
            'pixel','position',[200 170 20 20],...
            'string','27',...
            'Callback',@widthCallBack);
        
        % AP (I.E., X) UI SLIDER
        hSli = uicontrol('style','slider','units',...
            'pixel','position',[15 50 300 20],...
            'Max',1,'Min',-1,'Value',0,...
            'Callback',@apSliderCallBack);
        
        % AP (I.E., X) UI SLIDETER NAME
        hSli = uicontrol('style','text','units',...
            'pixel','position',[15 80 300 20],...
            'string','A-P alignment');
        
        % ML (I.E., Y) UI SLIDER
        hSli = uicontrol('style','slider','units',...
            'pixel','position',[15 110 300 20],...
            'Max',1,'Min',-1,'Value',0,...
            'Callback',@mlSliderCallBack);
        
        % ML (I.E., Y) UI SLIDETER NAME
        hSli = uicontrol('style','text','units',...
            'pixel','position',[15 140 300 20],...
            'string','M-L alignment');
        
        % PUSH BUTTON (OK)
        hPsh = uicontrol('style','pushbutton',...
            'String','Ok',...
            'position',[15 20 150 20],...
            'Callback',@pushOKCallBack);
        
        % PUSH BUTTON (CANCEL)
        hPsh = uicontrol('style','pushbutton',...
            'String','Cancel',...
            'position',[165 20 150 20],...
            'Callback',@pushCancelCallBack);
        uiwait;
    end

    function heightCallBack( handle, event )
        align(handle);
    end

    function widthCallBack( handle, event )
        align(handle);
    end

    function apSliderCallBack( handle, event )
        align(handle);
    end

    function mlSliderCallBack( handle, event )
        align(handle);
    end

    function pushOKCallBack( handle, event )
        uiresume;
        close(handle.Parent);
        guidata(hObject,model);
    end

    function pushCancelCallBack( handle, event )
        close(handle.Parent);
        uiresume
    end

    function align(handle)
        
        switch(func2str(handle.Callback));
            case('addCylAdap/heightCallBack')
                model.guiCylAdapHeight = str2double(handle.String);
            case('addCylAdap/widthCallBack')
                model.guiCylAdapWidth = str2double(handle.String);
            case('addCylAdap/mlSliderCallBack')
                guiYCircle = handle.Value * 10; % 10 mm resolution
            case('addCylAdap/apSliderCallBack')
                guiXCircle = handle.Value * 10; % 10 mm resolution
        end
        
        %**************************************************************************
        % use arbitrary height window beyond which the model is not modified.
        % Without this the cylindrical adapter will extend up through the top
        % region of the model.
        %**************************************************************************
%         heigthWindow = round(size(model.data,1) .* 1);
        
        %  COMPUTE ADAPTER CORDINATES
        newXCircle = guiXCircle - lastXCircle;
        newYCircle = guiYCircle - lastYCircle;
        x = newXCircle + (model.guiCylAdapWidth * cosd(theta));
        y = newYCircle + (model.guiCylAdapWidth * sind(theta));
        tmpAdapR = sqrt(x.^2 + y.^2)';
        
        % APPLY ADAPTER
        model.data = orgData;
        tmpModelR = sqrt(sum(model.data(:,1:2).^2,2));
        tmpModelR = reshape(tmpModelR,model.numSlicePoints,model.numSliceHeights/model.numSlicePoints);
        scaleFactor = bsxfun(@rdivide,tmpModelR,tmpAdapR); 
        loc = bsxfun(@le,tmpModelR,tmpAdapR);
        scaleFactor = scaleFactor .* loc;
        scaleFactor(scaleFactor==0) = 1;
        scaleFactor = reshape(scaleFactor,model.numSliceHeights,1);
        model.data(:,1:2) = bsxfun(@rdivide,model.data(:,1:2),scaleFactor);
        
        % ADD CYCLINDRICAL ADAPTER HEIGHT
        if model.guiCylAdapHeight ~= 0
            repNum = round(model.guiCylAdapHeight/model.sliceHeightStep)+1;
            tmp = repmat(model.data(1:model.numSlicePoints,1:2),repNum, 1);
            tmpz = (0:model.sliceHeightStep:model.guiCylAdapHeight)';
            model.sliceHeights = cat(1,tmpz,model.sliceHeights+model.guiCylAdapHeight);
            tmpz = repmat(tmpz,1,model.numSlicePoints);
            tmpz = reshape(tmpz,model.numSlicePoints*repNum,1);
            tmp = cat(2,tmp,tmpz);
            model.data = cat(1,tmp,model.data+model.guiCylAdapHeight);
            
            % RE-MESH MODEL
            model.faces = bsxfun(@plus, ones(model.numSlicePoints*(length(model.sliceHeights)-1)-1,4),...
            (0:(model.numSlicePoints*(length(model.sliceHeights)-1)-2))');
            model.faces = bsxfun(@plus,model.faces,[0,1,1+model.numSlicePoints,model.numSlicePoints]);
        end
        
        % DRAW SCENE
        set(model.handlePatch,'vertices',model.data,'faces',model.faces);
        drawnow;
        
        % SAVE DATA
        guidata(hObject,model);
    end
end



