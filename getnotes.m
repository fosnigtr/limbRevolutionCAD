function [ notes ] = getnotes()

% Model notes
notes.name='Extra Notes';
notes.prompt={'Enter any extra notes:'};
notes.defaultanswer={'none'};
notes.text=inputdlg(notes.prompt,notes.name,10,defaultanswer);
notes.text_mat=cell2mat(notes.text);

end

