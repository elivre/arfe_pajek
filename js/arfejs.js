UEs = ''

function loadUE(ano,uf) {

    $.ajax({
        url: "net.gefx" ,
        dataType: "txt",
        success: function(data) {
          UEs = $(data).val
          return 
        
        }
    }
}

$(document).ready(function() {
 
        $("#texto").load("net.gefx");

}
