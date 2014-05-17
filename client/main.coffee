Meteor.subscribe "all_i18n"
Session.set("idDocument-i18n", null)

Template.missing.helpers
    languages: ->
        _.unique(x.language for x in i18n.find().fetch())
    tags_missing : (language) ->
        tags_total = _.unique(x.tag for x in i18n.find().fetch())
        tags_language = (x.tag for x in i18n.find(language:language).fetch())
        _.difference tags_total, tags_language

Template.i18nForm.helpers
    type: -> if Session.get("idDocument-i18n") then 'update' else 'insert'
    doc: -> i18n.findOne _id: Session.get("idDocument-i18n")

Session.set "searchProperties", {tag: '', value: ''} 
        
Template.search.helpers
    items: -> 
        attrs = Session.get "searchProperties"
        tag = attrs.tag
        value = attrs.value
        i18n.find({tag: { $regex: '.*'+tag+'.*'}, value: { $regex: '.*'+value+'.*'}})

Template.search.events
    "click .edit": (e,t)->
        Session.set "idDocument-i18n", $(e.target).attr('_id')        
    "click .delete": (e,t) ->
        bootbox.dialog
            message: 'Your are going to delete an item.'
            title: 'alert!'
            buttons:
                success:
                    label: 'go on'
                    className: 'btn-success'
                    callback: ->
                        i18n.remove _id: $(e.target).attr('_id')
                cancel:
                    label: 'cancel'
                    className: 'btn-cancel'

@searchSchema = new SimpleSchema
    tag:
        type: String
        optional: true
    value:
        type: String  
        optional: true

AutoForm.hooks
    searchForm:
        before:
            "searchMethod": (doc) ->
                Session.set "searchProperties", {tag: doc.tag or '', value: doc.value or ''} 
                doc
        #onSubmit: -> false        