function [varargout] = getImages(varargin)
%gets images and converts them to black and white
%call using [img1, img2, ..] = getImages(); or
%           [img1, img2, ..] = getImages(xSizeMax);
% can be used to get any number of images at once
% can select multiple images an once
% xSizeMax is the maximum horizontal size of the images (larger ones are
% scaled down)

    pathName = 'C:\';
    varargout{max(nargout-1,1)} = [];
    
    %get file names
    fileList = cell(nargout,1);
    pathList = cell(nargout,1);
    
    i = 1;
    while(i <= nargout)
        [fileName, pathName] = uigetfile(...
            {'*.jpg;*.png;*.jpeg;*.gif;*.tiff;*.tif;*.bmp;*.mat','Image Files';...
            '*.*', 'All Files (*.*)'},...
            'Get Images',...
            pathName,...
            'MultiSelect', 'on');
        
        if(iscell(fileName))
            fileName = fileName';
            fileList(i:min(nargout,size(fileName,1)+i-1)) = fileName(1:min(nargout-i+1,size(fileName,1)));
            pathList(i:min(nargout,size(fileName,1)+i-1)) = num2cell(pathName,2);
            
            i = i + size(fileName,1);
        else
            fileList{i} = fileName;
            pathList{i} = pathName;
            
            i = i+1;
        end
    end
    
    %get files
    for i = 1:nargout

        if(isequal(strfind(fileList{i}, '.mat'),[]))
            img = imread([pathList{i}, fileList{i}]);

            if(size(img,3)==3)
                img = rgb2gray(img);
            end

            if(nargin == 1)
                sImg = varargin{1};
                if(size(img,2)>sImg)
                    img = imresize(img,sImg/size(img,2));
                end
            end  
        else
            img = load([pathList{i}, fileList{i}]);
            names = fieldnames(img);
            img = img.(names{1});
        end

        varargout{i} = img;
    end
end

