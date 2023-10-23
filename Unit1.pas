unit Unit1;

interface

uses
  System.SysUtils,
  System.Classes,
  System.DateUtils,

  JS,
  Web,
  jsdelphisystem,

  WEBLib.REST,
  WeBLib.JSON,

  WEBLib.Graphics,
  WEBLib.Controls,
  WebLib.WebTools,
  WEBLib.Forms,
  WEBLib.Dialogs,
  Vcl.Controls,
  WEBLib.ExtCtrls,
  WEBLib.WebCtrls;

type
  TForm1 = class(TWebForm)
    divPhotos: TWebHTMLDiv;
    tmrStart: TWebTimer;
    procedure WebFormCreate(Sender: TObject);
    [async] procedure tmrStartTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure PreventCompilerHint(I: integer); overload;
    procedure PreventCompilerHint(S: string); overload;
    procedure PreventCompilerHint(J: TJSONArray); overload;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.WebFormCreate(Sender: TObject);
begin
  tmrStart.Enabled := True;
end;

procedure TForm1.tmrStartTimer(Sender: TObject);
var
  Background: String;
  PhotoCount: Integer;
  FirstPerson: Integer;
  BorderRadius: String;

  URL: String;
  Endpoint: String;
  Secret: String;
  aMonth: Integer;
  ADay: Integer;

  WebRequest: TWebHTTPRequest;
  WebResponse: TJSXMLHTTPRequest;
  Data: String;
  JSONData: TJSONArray;

begin

  tmrStart.Enabled := False;

  // Number of People to Display
  if GetQueryParam('N') <> ''
  then PhotoCount := StrToIntDef(GetQueryParam('N'),10)
  else PhotoCount := 10;

  // Starting person to display
  if GetQueryParam('F') <> ''
  then FirstPerson := StrToIntDef(GetQueryParam('F'),1) - 1
  else FirstPerson := 0;

  // Width of Container
  if GetQueryParam('W') <> ''
  then divPhotos.Width := StrToIntDef(GetQueryParam('W'),972)
  else divPhotos.width := 972;

  // Height of Container
  if GetQueryParam('H') <> ''
  then divPhotos.Height := StrToIntDef(GetQueryParam('H'),574)
  else divPhotos.Height := 574;

  // X (Left) Offset of Container
  if GetQueryParam('X') <> ''
  then divPhotos.Left := StrToIntDef(GetQueryParam('X'),0)
  else divPhotos.Left := 0;

  // Y (Top) Offset of Container
  if GetQueryParam('Y') <> ''
  then divPhotos.Top := StrToIntDef(GetQueryParam('Y'),0)
  else divPhotos.Top := 0;

  // Scale of Container (Origin: Top Left)
  if GetQueryParam('S') <> ''
  then divPhotos.ElementHandle.style.setProperty('transform', 'scale('+GetQueryParam('S')+')')
  else divPhotos.ElementHandle.style.setProperty('transform', 'scale(1)');

  // Background (Color, etc.)
  if GetQueryParam('B') <> ''
  then Background := GetQueryParam('B')
  else Background := 'black';
  asm
    document.body.style.setProperty('background', Background, "important");
  end;

  // Border Radius
  if GetQueryParam('R') <> ''
  then BorderRadius := GetQueryParam('R')
  else BorderRadius := '6px';

  // Select a different month than today's month
  if GetQueryParam('M') <> ''
  then aMonth := StrToIntDef(getQueryParam('M'), MonthOfTheYear(Now))
  else aMonth := MonthOfTheYear(Now);

  // Select a different day than today's day
  if GetQueryParam('D') <> ''
  then aDay := StrToIntDef(getQueryParam('D'),DayOfTheMonth(Now))
  else aDay := DayOfTheMonth(Now);

  // Setup for Query
  URL := 'https://carnival.500foods.com:10999';
  Endpoint := '/actorious/ActorInfoService/TopToday';
  Secret := 'LeelooDallasMultiPass';


  // Make the request
  WebRequest := TWebHTTPRequest.Create(Self);
  WebRequest.URL := URL+Endpoint+'?Secret='+Secret+'&aMonth='+IntToStr(aMonth)+'&aDay='+IntToStr(aDay);
  WebResponse := await(TJSXMLHTTPRequest, WebRequest.Perform());

  try
    // This will hopefully raise an exception if we didn't get valid data
    // Which should end up in a blank page as a result, with the error logged to the console
    Data := String(WebResponse.Response);
    JSONData := TJSONObject.ParseJSONValue(Data) as TJSONArray;

    asm
      // The result is a JSON array with each array element corresponding to a person
      // The array should already be int he correct order, so we just need to display them.
      var photos = JSON.parse(Data);

      // This just encodes an integer value into a diffrent Base numbering, kind of like a link shortener. Sort of. Base48 in this case.
      // The idea was to get a value that didn't have any values or characters that are easily confused with one another, in case someone
      // actually had to type one out. Also, to reduce the likelihood of assigning an actual valid word (no vowels for example).
      // https://github.com/marko-36/base29-shortener
      const c = ['B','b','C','c','D','d','F','f','G','g','H','h','J','j','K','k','L','M','m','N','n','P','p','Q','q','R','r','S','s','T','t','V','W','w','X','x','Z','z','0','1','2','3','4','5','6','7','8','9'];
      function obscure(i){
        i = i + 10000;
        var sLen = Math.floor(Math.log(i)/Math.log(c.length)) +1;
        var s = '';
        for(var ex=sLen-1; ex>-1; --ex){
          s += c[Math.floor(i / Math.pow(c.length,ex))];
          i = [i % Math.pow(c.length,ex)];
        }
        return s;
      }

      // Setup <div> that holds all the photos
      divPhotos.style.setProperty("transform-origin","top left");
      divPhotos.style.setProperty("background","transparent");
      divPhotos.style.setProperty("display","flex");
      divPhotos.style.setProperty("gap","4px");
      divPhotos.style.setProperty("padding","4px");
      divPhotos.style.setProperty("align-content","flex-start");
      divPhotos.style.setProperty("overflow","hidden");
      divPhotos.style.setProperty("flex-wrap","wrap");

      // Do this for as many photos as we'd like to see
      for (var i = FirstPerson; i < (FirstPerson + PhotoCount); i++) {

        // Create a <div> element to hold the photo
        var div = document.createElement("div");
        div.setAttribute("id","divPhoto"+i);
        div.style.setProperty("display","flex");
        div.style.setProperty("order",i);
        div.style.setProperty("width","185px");
        div.style.setProperty("height","278px");

        // Within that, we want an <a> element to provide a link to the Actorious website with a valid identifier
        var anchor = document.createElement("a");
        anchor.setAttribute("target","_blank");
        anchor.setAttribute("href","https://www.actorious.com/?R=P"+obscure(parseInt(photos[i].TID))+'-'+photos[i].NAM.replace(' ','-'));

        // Within that, add the actual image
        var img = document.createElement("img");
        img.setAttribute("id","imgPhoto"+i);
        img.setAttribute("class","Photo border border-2 border-dark");
        img.setAttribute("title",photos[i].NAM)
        img.setAttribute("src","https://image.tmdb.org/t/p/w185"+photos[i].PIC);
        img.setAttribute("onerror","this.src='https://www.actorious.com/img/person-placeholder.png';this.onerror='';");
        img.style.setProperty("display","flex");
        img.style.setProperty("width","185px");
        img.style.setProperty("height","278px");
        img.style.setProperty("border-radius", BorderRadius);

        // Add them to the page
        divPhotos.appendChild(div);
        div.appendChild(anchor);
        anchor.appendChild(img);
      }
    end;
  except on E: Exception do
    begin
      console.log('[ '+E.ClassName+' ] '+E.Message);
    end
  end;

  // This is just to supress the "local variable is assigned but never used" messages
  PreventCompilerHint(Background);
  PreventCompilerHint(PhotoCount);
  PreventCompilerHint(FirstPerson);
  PreventCompilerHint(BorderRadius);
  PreventCompilerHint(JSONData);
end;

procedure TForm1.PreventCompilerHint(S: string);               overload; begin end;
procedure TForm1.PreventCompilerHint(I: integer);              overload; begin end;
procedure TForm1.PreventCompilerHint(J: TJSONArray);           overload; begin end;

end.