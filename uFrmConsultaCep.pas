unit uFrmConsultaCep;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, REST.Types, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Vcl.StdCtrls, Vcl.Buttons, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, REST.Response.Adapter, REST.Client,
  Data.Bind.Components, System.JSON,   Data.Bind.ObjectScope, Vcl.Grids, Vcl.DBGrids;

type
  TFrmTestePratico = class(TForm)
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    RESTResponseDataSetAdapter1: TRESTResponseDataSetAdapter;
    BitBtn1: TBitBtn;
    Label1: TLabel;
    EditCep: TEdit;
    cbApi: TComboBox;
    Label2: TLabel;
    EditRua: TEdit;
    EditBairo: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    EditEstado: TEdit;
    Label6: TLabel;
    EditCidade: TEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure EditCepKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure awesomeapi(cep:string);
    procedure apicep(cep:string);
  public
    { Public declarations }
  end;

var
  FrmTestePratico: TFrmTestePratico;

implementation


{$R *.dfm}

procedure TFrmTestePratico.apicep(cep: string);
var
  Json : TJSONObject;
  lCep: string;
begin

// https://cdn.apicep.com/file/apicep/32370-033.json
   try
    try
     lCep := copy(cep,1,5);
     lCep := lCep + '-' + copy(cep,6,3);
     RESTClient1.BaseURL := 'https://cdn.apicep.com/file/apicep/'+ lCep +'.json';
     RESTRequest1.Execute;
     Json  := TJSONValue.ParseJSONValue(RESTRequest1.Response.JSONText) as TJSONObject;
     EditRua.Text      :=  StringReplace(Json.Values['address'].ToString, '"', '', [rfReplaceAll]);
     EditBairo.Text    :=  StringReplace(Json.Values['district'].ToString, '"', '', [rfReplaceAll]);
     EditEstado.text   :=   StringReplace(Json.Values['state'].ToString, '"', '', [rfReplaceAll]);
     EditCidade.Text   :=   StringReplace(Json.Values['city'].ToString, '"', '', [rfReplaceAll]);
    except
      ShowMessage('Erro ao consultar o cep!') ;
    end;
   finally
     Json.Free;
   end;

end;

procedure TFrmTestePratico.awesomeapi(cep: string);
var
  Json : TJSONObject;
begin
  try
   try
    RESTClient1.BaseURL := 'https://cep.awesomeapi.com.br/json/' + cep;
    RESTRequest1.Execute;
    Json  := TJSONValue.ParseJSONValue(RESTRequest1.Response.JSONText) as TJSONObject;
    EditRua.Text      :=  StringReplace(Json.Values['address'].ToString, '"', '', [rfReplaceAll]);
    EditBairo.Text    :=  StringReplace(Json.Values['district'].ToString, '"', '', [rfReplaceAll]);
    editEstado.text   :=  StringReplace(Json.Values['state'].ToString, '"', '', [rfReplaceAll]);
    EditCidade.Text   :=  StringReplace(Json.Values['city'].ToString, '"', '', [rfReplaceAll]);
   except
      ShowMessage('Erro ao consultar o cep!');
    end;
  finally
    Json.Free;
  end;

end;

procedure TFrmTestePratico.BitBtn1Click(Sender: TObject);
begin
 if cbApi.ItemIndex = -1  then
  begin
    ShowMessage('Selecione uma API');
    exit
  end;

  if EditCep.Text  =  EmptyStr then
   begin
     ShowMessage('Informe o cep');
     exit
   end;


  case  cbApi.ItemIndex  of
   0:begin
     awesomeapi(EditCep.Text);
   end;
   1:begin
      apicep(EditCep.Text);
    end;
  end;

end;

procedure TFrmTestePratico.EditCepKeyPress(Sender: TObject; var Key: Char);
begin

 if not CharInSet(Key, ['0'..'9',#8]) then
 begin
   Key := #0;
 end;

end;


end.
