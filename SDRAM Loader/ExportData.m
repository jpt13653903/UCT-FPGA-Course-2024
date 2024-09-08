function ExportData(Data, Filename)
    % This is MUCH faster than doing it by for-loop
    disp(['Converting "' Filename '"...']);
    HexData = reshape(dec2hex(fliplr(Data), 2)', 1, []);

    disp('Writing...');
    File = fopen([Filename '.dat'], 'wb');
        fprintf(File, HexData);
    fclose(File);

    disp('Done');
end
%% -----------------------------------------------------------------------------

