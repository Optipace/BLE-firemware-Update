class DataController{
  String? Text;
  var obj = null;

  DataController(){
    Text="";
  }
  set setText(String? value){
    Text = value;
  }
  set setobj(var value) {
    obj = value;
  }
  String? get getText {
    return Text.toString();
  }
  get getobj {
    return obj;
  }
}