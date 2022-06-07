unit uWVWindowParent;

{$IFDEF FPC}{$MODE Delphi}{$ENDIF}
{$I webview2.inc}

interface

uses
  {$IFDEF FPC}
  Classes, Controls, LResources,
  {$ELSE}
  {$IFDEF DELPHI16_UP}
  WinApi.Windows, System.Classes, Vcl.Controls,
  {$ELSE}
  Windows, Classes, Controls,
  {$ENDIF}
  {$ENDIF}
  uWVWinControl, uWVBrowserBase;

type
  {$IF NOT(DEFINED(FPC)) AND DEFINED(DELPHI16_UP)}[ComponentPlatformsAttribute(pidWin32 or pidWin64)]{$IFEND}
  TWVWindowParent = class(TWVWinControl)
    protected
      FBrowser : TWVBrowserBase;

      function  GetBrowser : TWVBrowserBase;

      procedure SetBrowser(const aValue : TWVBrowserBase);

      procedure Notification(AComponent: TComponent; Operation: TOperation); override;
      procedure Resize; override;

    public
      constructor Create(AOwner : TComponent); override;
      procedure   UpdateSize; override;
      procedure   SetFocus; override;

    published
      property Browser     : TWVBrowserBase   read GetBrowser     write SetBrowser;
  end;

{$IFDEF FPC}
procedure Register;
{$ENDIF}

implementation

constructor TWVWindowParent.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FBrowser := nil;
end;

procedure TWVWindowParent.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);

  if (Operation = opRemove) and (AComponent = FBrowser) then
    FBrowser := nil;
end;

procedure TWVWindowParent.Resize;
begin
  inherited Resize;

  UpdateSize;
end;

function TWVWindowParent.GetBrowser: TWVBrowserBase;
begin
  Result := FBrowser;
end;

procedure TWVWindowParent.SetBrowser(const aValue : TWVBrowserBase);
begin
  FBrowser := aValue;

  if (aValue <> nil) then
    aValue.FreeNotification(Self);
end;

procedure TWVWindowParent.UpdateSize;
begin
  if (FBrowser <> nil) then
    FBrowser.Bounds := ClientRect
   else
    inherited UpdateSize;
end;

procedure TWVWindowParent.SetFocus;
begin
  inherited SetFocus;

  if (FBrowser <> nil) then
    FBrowser.SetFocus;
end;

{$IFDEF FPC}
procedure Register;
begin
  {$I res/twvwindowparent.lrs}
  RegisterComponents('WebView4Delphi', [TWVWindowParent]);
end;
{$ENDIF}

end.
