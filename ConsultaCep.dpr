program ConsultaCep;

uses
  Vcl.Forms,
  uFrmConsultaCep in 'uFrmConsultaCep.pas' {FrmTestePratico};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmTestePratico, FrmTestePratico);
  Application.Run;
end.
