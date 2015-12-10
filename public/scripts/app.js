function Summary(data) {
    var self = this;
    self.user_name = ko.observable(data.user_name);
    self.full_name = ko.observable(data.full_name);
    self.site_country = ko.observable(data.site_country);
    self.site_sp = ko.observable(data.site_sp);
    self.location_country = ko.observable(data.location_country);
    self.location_sp = ko.observable(data.location_sp);
    self.port_access = ko.observable(data.port_access);
    self.login_time = ko.observable(data.login_time);
    self.time_active = ko.observable(data.time_active);


}

function SummaryViewModel() {
    var self = this;
    self.summaries = ko.observableArray();
    $.ajax({
        url: "/summary",
        cache: false,
        type: 'GET',
        contentType: 'application/json; charset=utf-8',
        data: {},
        success: function (data) {
            var summary = new Summary(data);
            self.summaries(summary); //Putting the response in ObservableArray
        }
    });
}
var summaryViewModel = new SummaryViewModel();
ko.applyBindings(summaryViewModel);

//s.newTaskDesc = ko.observable();
//s.updateSummary = function() {
//    var newtask = new Task({ description: this.newTaskDesc() });
//    $.getJSON("/getdate", function(data){
//        newtask.created_at(data.date);
//        newtask.updated_at(data.date);
//        t.tasks.push(newtask);
//        t.saveTask(newtask);
//        t.newTaskDesc("");
//    })
//};
//
//t.saveTask = function(task) {
//    var t = ko.toJS(task);
//    $.ajax({
//        url: "http://localhost:9393/tasks",
//        type: "POST",
//        data: t
//    }).done(function(data){
//        task.id(data.task.id);
//    });
//}