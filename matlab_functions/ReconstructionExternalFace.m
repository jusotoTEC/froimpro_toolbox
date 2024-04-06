function [] = ReconstructionExternalFace(Textpath,W,NameOutput)
    % Esta función recibe un ruta de una imagen y usa la matriz base W (generada con 
    % la función ConstructionNNFM) para reconstruirla y así evaluar la calidad de la base de caras W. 
    % Esta función guarda la nueva imagen en formato jpg, en el directorio "Results" dentro 
    % de la carpeta de trabajo. Si no existe, la crea automáticamente.
    %
    % Para más información ver el manual del Toolbox en <a href="matlab: 
    % web('https://tecnube1-my.sharepoint.com/:b:/g/personal/jfallas_itcr_ac_cr/ES65Im0jm15AvNH9XtsS8uwBvzdPE-U8CHa11fWpLCZGRw?e=fLPthq')"> Manual del Toolbox norma de Frobenius</a>.
    %
    % Sintaxis: ReconstructionExternalFace('Textpath',W,'NameOutput')
    %
    % Parámetro de entrada:    
    %       TextPath:   Ruta de la imagen que desea reconstruir.       
    %       W:          Es la matriz que representa la base de caras. Esta matriz se 
    %                   obtiene al ejecutar la función ConstructionNNFM.
    %       NameOutput: Es el nombre que se utilizará para guardar la imagen reconstruida.

    ValidMatrix = @(x) ismatrix(x) && isnumeric(x);
    if ValidMatrix(W)==0 
        error('The value of W is not valid');
    end
    direccion=strcat('Results\ReconstructedFaces');
    if exist(direccion)~=7 %Valida la existencia de la carpeta "Results"
        mkdir(direccion);
    end
    ImagenExterna=im2double(imread(Textpath));
    [m,n]=size(ImagenExterna);
    ImagenExternaVector=reshape(ImagenExterna,[m*n 1]);
    CoefImagenExterna=pinv(W)*ImagenExternaVector;
    ImagenReconstruidaVector=W*CoefImagenExterna;
    ImagenReconstruida=reshape(ImagenReconstruidaVector,[m n]);
    imwrite(ImagenReconstruida,strcat(direccion,'\',NameOutput,'.jpg'));
    imwrite(ImagenExterna,strcat(direccion,'\',NameOutput,'_Original.jpg'));
end

