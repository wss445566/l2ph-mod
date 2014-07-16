unit uPlugins;

interface

uses
    Windows,
    usharedstructs,
    uPluginData,
    Menus,
    Messages,
    SysUtils,
    Variants,
    Classes,
    Graphics,
    Controls,
    Forms,
    Dialogs,
    StdCtrls,
    ExtCtrls,
    CheckLst,
    siComp;

type

    TfPlugins = class (TForm)
        GroupBox5 : TGroupBox;
        clbPluginsList : TCheckListBox;
        Panel13 : TPanel;
        GroupBox10 : TGroupBox;
        mPluginInfo : TMemo;
        GroupBox11 : TGroupBox;
        clbPluginFuncs : TCheckListBox;
        Panel1 : TPanel;
        btnRefreshPluginList : TButton;
        lang : TsiLang;
        procedure btnRefreshPluginListClick(Sender : TObject);
        procedure FormCreate(Sender : TObject);
        procedure FormDestroy(Sender : TObject);
        procedure N6Click(Sender : TObject);
        procedure clbPluginsListClickCheck(Sender : TObject);
        procedure clbPluginsListClick(Sender : TObject);
    protected
        procedure CreateParams(var Params : TCreateParams); override;
    private
    { Private declarations }
    public
        procedure init;
    { Public declarations }
    end;

var
    fPlugins : TfPlugins;

implementation

uses
    uScripts,
    uMain,
    uGlobalFuncs,
    uData,
    uUserForm,
    Math,
    uMainReplacer;

{$R *.dfm}

procedure TfPlugins.btnRefreshPluginListClick(Sender : TObject);
var
    SearchRec : TSearchRec;
    Mask, s : string;
    mi : TMenuItem;
    newplugin : TPlugin;
    i : integer;
begin
  //Mask := ExtractFilePath(ParamStr(0))+'plugins\*.dll';
    Mask := AppPath + 'plugins\*.dll';
    clbPluginsList.Clear;
    while Plugins.Count > 0 do
    begin
        TPlugin(Plugins.Items[0]).Destroy;
    end;

    fMain.nPlugins.Clear;

    if FindFirst(Mask, faAnyFile, SearchRec) = 0 then
    begin
        repeat
            Application.ProcessMessages;
            if (SearchRec.Attr and faDirectory) <> faDirectory then
            begin
                newplugin := TPlugin.Create;
        //newplugin.FileName := ExtractFilePath(ParamStr(0))+'plugins\'+SearchRec.Name;
                newplugin.FileName := AppPath + 'plugins\' + SearchRec.Name;
                s := Copy(SearchRec.Name, 1, Length(SearchRec.Name) - 4);
                clbPluginsList.Items.Add(s);
                mi := TMenuItem.Create(fMain.nPlugins);
                fMain.nPlugins.Add(mi);
                mi.AutoCheck := true;
                mi.Checked := false;
                mi.Caption := s;
                mi.OnClick := N6Click;
            end;
        until FindNext(SearchRec) <> 0;
        FindClose(SearchRec);
    end;

    i := 0;
    while i < clbPluginsList.Count do
    begin
        clbPluginsList.Checked[i] := Options.ReadBool('plugins', clbPluginsList.Items.Strings[i], false);
        if clbPluginsList.Checked[i] then
        begin
            clbPluginsList.ItemIndex := i;
            clbPluginsListClickCheck(nil);
        end;
        inc(i);
    end;
end;

//Это не дубляж.
//Поддержка старых версий плагиноф


procedure TfPlugins.FormCreate(Sender : TObject);
begin
    loadpos(self);
end;

procedure TfPlugins.FormDestroy(Sender : TObject);
begin
    savepos(self);

    while Plugins.Count > 0 do
    begin
        TPlugin(Plugins.Items[0]).Destroy;
    end;

    Plugins.Destroy;
    PluginStruct.Destroy;
end;

procedure TfPlugins.N6Click(Sender : TObject);
begin
    clbPluginsList.Checked[TMenuItem(Sender).MenuIndex] := TMenuItem(Sender).Checked;
    clbPluginsList.ItemIndex := TMenuItem(Sender).MenuIndex;
    clbPluginsListClickCheck(nil);
end;

procedure TfPlugins.clbPluginsListClickCheck(Sender : TObject);
var
    i : integer;
begin
    i := clbPluginsList.ItemIndex;
    if i = -1 then
    begin
        Exit;
    end;

    if clbPluginsList.Checked[i] then
    begin
        clbPluginsList.Checked[i] := TPlugin(Plugins.Items[i]).LoadPlugin;
    end
    else
    begin
        TPlugin(Plugins.Items[i]).FreePlugin;
    end;

    fMain.nPlugins.Items[i].Checked := clbPluginsList.Checked[i];

    if Sender = nil then
    begin
        exit;
    end;
  //обновляем автокомплиты
    Options.WriteBool('plugins', clbPluginsList.Items.Strings[i], clbPluginsList.Checked[i]);
    SendMessage(fMainReplacer.Handle, WM_UpdAutoCompleate, 0, 0);

end;

procedure TfPlugins.clbPluginsListClick(Sender : TObject);
var
    i : integer;
begin
    mPluginInfo.Clear;
    for i := 0 to 6 do
    begin
        clbPluginFuncs.Checked[i] := false;
    end;

    if clbPluginsList.ItemIndex = -1 then
    begin
        Exit;
    end;

    with TPlugin(Plugins.Items[clbPluginsList.ItemIndex]) do
    begin
        if Loaded then
        begin
            mPluginInfo.Lines.Add(Info);
            for i := 0 to 6 do
            begin
                if TEnableFunc(i) in EnableFuncs then
                begin
                    clbPluginFuncs.Checked[i] := true;
                end;
            end;
        end
        else
        if LoadInfo then
        begin
            mPluginInfo.Lines.Add(Info);
            for i := 0 to 6 do
            begin
                if TEnableFunc(i) in EnableFuncs then
                begin
                    clbPluginFuncs.Checked[i] := true;
                end;
            end;
        end;
    end;
end;

{ TActiveConnections }


procedure TfPlugins.CreateParams(var Params : TCreateParams);
begin
    inherited;
    Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
end;

procedure TfPlugins.init;
begin
    Plugins := TList.Create;
    PluginStruct := TPluginStructClass.create;
    btnRefreshPluginList.Click;
    dmData.DO_reloadFuncs;//обновляем доступные скриптам функции
end;

end.
