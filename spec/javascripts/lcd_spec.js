(function() {

  describe('Lcd', function() {
    var lcd;
    lcd = new Lcd('prefix');
    beforeEach(function() {
      return $('#jasmine_content').html("<table>\n  <tr>\n    <td class=\"lcd0\" id=\"prefix100s\" />\n    <td class=\"lcd0\" id=\"prefix10s\" />\n    <td class=\"lcd0\" id=\"prefix1s\" />\n  </tr>\n</table>");
    });
    it('should display 0', function() {
      lcd.display(0);
      expect($('#prefix1s').attr('class')).toEqual('lcd0');
      expect($('#prefix10s').attr('class')).toEqual('lcd0');
      return expect($('#prefix100s').attr('class')).toEqual('lcd0');
    });
    it('should display 1', function() {
      lcd.display(1);
      expect($('#prefix1s').attr('class')).toEqual('lcd1');
      expect($('#prefix10s').attr('class')).toEqual('lcd0');
      return expect($('#prefix100s').attr('class')).toEqual('lcd0');
    });
    it('should display 10', function() {
      lcd.display(10);
      expect($('#prefix1s').attr('class')).toEqual('lcd0');
      expect($('#prefix10s').attr('class')).toEqual('lcd1');
      return expect($('#prefix100s').attr('class')).toEqual('lcd0');
    });
    return it('should display 100', function() {
      lcd.display(100);
      expect($('#prefix1s').attr('class')).toEqual('lcd0');
      expect($('#prefix10s').attr('class')).toEqual('lcd0');
      return expect($('#prefix100s').attr('class')).toEqual('lcd1');
    });
  });

}).call(this);