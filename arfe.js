function loadUE(ano,uf) {

    $.ajax({
        url: "net.gefx" ,
        dataType: "xml",
        success: function(data) {
          return $(data)
        
        }
    }
}
