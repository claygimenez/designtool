FormAttributes = function(form) {
  this.form = form;
}

_.extend(FormAttributes.prototype, {
  attributes: function() {
    var attributes = {};
    _.each($('input, select', this.form), function(element) {
      var element = $(element);
      if(element.attr('name') && element.attr('name') != "commit") {
        attributes[element.attr('name')] = element.val();
      }
    });
    return attributes;
  }
});
