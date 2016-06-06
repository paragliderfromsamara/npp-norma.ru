# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

frm = "<tbody id = \"val_rows\"></tbody><tbody id = \"form_row\"><tr><td colspan='2'><input id=\"col_1\" type = \"text\" size = \"40\"/></td><td colspan='2'><input id=\"col_2\" type = \"text\" size = \"40\"/></td></tr><tr><td colspan = 4><a id = \"addRowBut\"><i class = \"fi-plus pointer\"></i> Добавить строку</a></td><td></td></tr></tbody>"
tblRow = (c1, c2, isValField, i)->
    v = ""
    if isValField
        v += "<td style = \"width:30px; \">"
        v += "<a class = \"move_up\" val = \"#{i}\"><i class = \"fi-arrow-up\"></i></a> "
        v += "<a class = \"move_down\" val = \"#{i}\"><i class = \"fi-arrow-down\"></i></a>"
        v += "</td>"
    v += "<td>#{c1}</td><td>#{c2}</td>"
    if isValField then v += "<td style = \"width:30px; \"><a val = \"#{i}\" class = \"rmv_row\"><i class = \"fi-x\"></a></td>"
    "<tr>#{v}</tr>"

    

rowsArray = new Array()

buildArrayFromValue = ()->
    v = $.trim($("#product_table_rows").val())
    newArr = new Array()
    sArr = new Array()
    lsIndex = 0
    leIndex = 0
    f = true
    i = 0
    if v.length > 0
        while f
            lsIndex = v.indexOf("<td>", lsIndex)
            leIndex = v.indexOf("</td>", leIndex)
            if leIndex is -1 or leIndex is -1 
                f = false
                break
            else
                sArr.push v[lsIndex+4..leIndex-1]
                lsIndex += 4
                leIndex += 5
                if sArr.length == 2 
                    newArr.push(sArr)
                    sArr = new Array()
    rowsArray = newArr
            
    

rmvRow = (el)->
    v = parseInt($(el).attr("val"))
    newArr = new Array()
    if rowsArray.length > 1
        for i in [0..rowsArray.length-1]
            if i isnt v then newArr.push rowsArray[i]
    rowsArray = newArr
    updFields()
    
mvUp = (el)->
    v = parseInt($(el).attr("val"))
    newArr = new Array()
    if v > 0 and rowsArray.length > 0
       for i in [0..rowsArray.length-1]
           if i is v-1
               newArr[newArr.length] = rowsArray[i+1]
               newArr[newArr.length] = rowsArray[i]                  
           else if i isnt v then newArr.push(rowsArray[i])
    else
        v = rowsArray.shift()
        newArr = rowsArray
        newArr.push(v)
    rowsArray = newArr
    updFields()


mvDwn = (el)->
    v = parseInt($(el).attr("val"))
    newArr = new Array()
    if v < rowsArray.length - 1 and rowsArray.length > 0
       for i in [0..rowsArray.length-1]
           if i is v
               newArr[newArr.length] = rowsArray[i+1]
               newArr[newArr.length] = rowsArray[i]                  
           else if i isnt v+1 then newArr.push(rowsArray[i])
    else
        v = rowsArray.pop()
        newArr = rowsArray
        newArr.unshift(v)
    rowsArray = newArr
    updFields()

updFields = ()->
    t = ""
    v = ""
    if rowsArray.length > 0
        for i in [0..rowsArray.length-1]
            t += tblRow(rowsArray[i][0], rowsArray[i][1], true, i)
            v += tblRow(rowsArray[i][0], rowsArray[i][1], false, i)
    $("#val_rows").html(t)
    $("#product_table_rows").val(v)
    $(".rmv_row").bind("click", ()-> rmvRow(this))
    $(".move_up").bind("click", ()-> mvUp(this))
    $(".move_down").bind("click", ()-> mvDwn(this))
    
addRow = ()->
    val1 = $.trim $("#col_1").val()
    val2 = $.trim $("#col_2").val()
    if val1.length > 0 and val2.length > 0
        rowsArray.push([val1, val2])
        updFields()
        $("#col_1, #col_2").val("")  

initTableRowsPanel = ()->
    $("#tableRowsPanel").html("<table id = \"val_rows_table\">#{frm}</table>")
    buildArrayFromValue()
    updFields()
    $("#addRowBut").bind("click", addRow)


r = ()-> 
    $("#p_photo").load(()-> 
                            $("#p_mini_container").width($("#p_photo").width())
                      )
    initTableRowsPanel()
     

$(document).ready r
$(document).on "page:load", r