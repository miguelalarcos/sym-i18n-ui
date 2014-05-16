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
    type: if Session.get("idDocument-i18n") then 'update' else 'insert'
        
Template.search.helpers
    items: -> i18n.find()