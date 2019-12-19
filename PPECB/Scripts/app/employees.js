$("#save-employees-btn").on("click", function () {
    this.disabled = true;
    $("#cancel-employees-btn").attr('disabled', 'disabled');
    $("#save-employees-btn").html('Saving...');
    var isValid = isValidForm();
    if (isValid === false) {
        $("#firstname").focus();
        $("#modal-task-failed").modal();
        $("#save-employees-btn").removeAttr('disabled');
        $("#cancel-employees-btn").removeAttr('disabled');
        $("#save-employees-btn").html('Save');
        return;
    }
    var firstname = $("#firstname").val();
    var lastname = $("#lastname").val();
    var dob = $("#dob").val();
    var gender = $("#gender").val();
    var department = $("#department").val();
    var active = $("#active").prop("checked");
    var id = $("#id").val();
    var data = { Firstname: firstname, Lastname: lastname, DOB: dob, Gender: gender, Department: department, Active: active, Id: id };
    var parms = JSON.stringify({ employee: data });
    $.ajax({
        type: "POST",
        url: 'services/ppecb.asmx/save',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: parms,
        async: true,
        success: function (res) {
            $("#modal-task").modal();
            $("#save-employees-btn").removeAttr('disabled');
            $("#cancel-employees-btn").removeAttr('disabled');
            $("#save-employees-btn").html('Save');
            $("#firstname").val(null);
            $("#firstname").focus();
            fetchEmployees();
        },
        error: function () {
            $("#firstname").focus();
            $("#modal-task-failed").modal();
            $("#save-employees-btn").removeAttr('disabled');
            $("#cancel-employees-btn").removeAttr('disabled');
            $("#save-employees-btn").html('Save');
        }
    });
});

$("#cancel-employees-btn").on("click", function () {
    this.disabled = true;
    resetForm();
});

$(document).ready(function () {
    fetchEmployees();
});

function fetchEmployees() {
    $("#employees-items-header").html('Fetching employees, one moment...');
    $.ajax({
        type: "POST",
        url: 'services/ppecb.asmx/getemployees',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        async: true,
        success: function (res) {
            var employees = JSON && JSON.parse(res.d) || $.parseJSON(res.d);
            $("#employees-items-header").html(null);
            var content = '';
            var count = res.length;
            $.each(employees, function (key, item) {
                var isActive = item.Active ? 'Yes' : 'No';
                var dob = item.DOB.split('T')[0];
                content += '<tr>';
                content += '    <td>'
                content += '        ' + item.Firstname;
                content += '    </td>';
                content += '    <td>'
                content += '        ' + item.Lastname;
                content += '    </td>';
                content += '    <td>'
                content += '        ' + dob;
                content += '    </td>';
                content += '    <td>'
                content += '        ' + item.Gender;
                content += '    </td>';
                content += '    <td>'
                content += '        ' + item.Department;
                content += '    </td>';
                content += '    <td>'
                content += '        ' + isActive;
                content += '    </td>';
                content += '    <td>'
                content += '        <span class="pull-right"><a style="cursor: pointer;" onclick="deleteEmployee(' + item.Id + ');">Delete</a> | <a style="cursor: pointer;" onclick="editEmployee(' + item.Id + ');">Edit</a></span>';
                content += '    </td>';
                content += '</tr>';
            });
            if (count !== 0) {
                $("#employees-items-body").html(content);
                $("#employees-items").DataTable({ 'paging': true, 'lengthChange': false, 'searching': false, 'ordering': false, 'info': false, 'autoWidth': true, 'destroy': true, 'retrieve': true });
                $("#employees").removeAttr('disabled');
                resetForm();
            } else {
                $("#employees-items-body").html('Employees database is empty. Add new employee and <b>Save</b>');
            }
            $("#save-employees-btn").removeAttr('disabled');
            $("#cancel-employees-btn").removeAttr('disabled');
        },
        error: function () {
            $("#employees-items-header").html(null);
            $("#modal-task-failed").modal();
        }
    });
}

function deleteEmployee(id) {
    window.alert('Please wait while task completes. Press OK to continue.');
    var parms = JSON.stringify({ id: id });
    $.ajax({
        type: "POST",
        url: 'services/ppecb.asmx/delete',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: parms,
        async: true,
        success: function (res) {
            $("#modal-task").modal();
            fetchEmployees();
        },
        error: function () {
            $("#modal-task-failed").modal();
        }
    });
}

function editEmployee(id) {
    window.alert('Please wait while task completes. Press OK to continue.');
    var parms = JSON.stringify({ id: id });
    $.ajax({
        type: "POST",
        url: 'services/ppecb.asmx/get',
        contentType: "application/json; charset=utf-8",
        dataType: "json",
        data: parms,
        async: true,
        success: function (res) {
            var employee = JSON && JSON.parse(res.d) || $.parseJSON(res.d);
            $("#id").val(employee.Id);
            $("#firstname").val(employee.Firstname);
            $("#lastname").val(employee.Lastname);
            $("#dob").val(employee.DOB.split('T')[0]);
            $("#gender").val(employee.Gender);
            $("#department").val(employee.Department);
            $("#active").prop("checked", employee.Active);
        },
        error: function () {
            $("#modal-task-failed").modal();
        }
    });
}

function resetForm() {
    $("#id").val(0);
    $("#firstname").val(null);
    $("#lastname").val(null);
    $("#dob").val(null);
    $("#gender").val('M');
    $("#department").val('IT');
    $("#active").prop("checked", true);
}

function isValidForm() {
    var firstname = $("#firstname").val();
    var lastname = $("#lastname").val();
    var dob = document.getElementById("dob");
    if (firstname === '' || lastname === '') {
        return false;
    }
    if (dob) {
        var check = dob.checkValidity();
        if (check === false) {
            return false;
        }
    }
    return true;
}