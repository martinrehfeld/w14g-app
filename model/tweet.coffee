class App.Models.Tweet extends Backbone.Model
  self = @

  initialize: ->
    @analyze()

  analyze: ->
    words = @extractEntities()
    @set analysedWords: words.concat @extractWords(@get 'textWithoutEntities')

  extractEntities: ->
    entities    = @get 'entities'
    emptyText   = self.emptyText
    text        = @get 'text'
    indices     = _.map entities.urls.concat(entities.hashtags, entities.user_mentions), (entity) -> entity.indices
    entityWords = []

    for [startIndex, endIndex] in indices
      entityWords.push text[startIndex...endIndex]
      text = text[0...startIndex] + emptyText[startIndex...endIndex] + text[endIndex..]

    @set textWithoutEntities: text
    entityWords

  buildDisplayText: ->
    urls         = @get('entities').urls
    text         = @get 'text'
    textPosition = 0
    textParts    = []

    for url in urls
      [startIndex, endIndex] = url.indices
      expandedUrl = url.expanded_url ? url.url
      link = "<a href=\"#{url.url}\">#{expandedUrl}</a>"
      textParts.push App.escapeHTML(text[textPosition...startIndex])
      textParts.push link
      textPosition = endIndex

    textParts.push App.escapeHTML(text[textPosition..])
    text = textParts.join('')
    @set displayText: text
    text

  extractWords: (text) ->
    stopWordRegex = self.stopWordRegex
    _.compact _.map text.toLocaleLowerCase().replace(/[!"()+*?&.,;:0-9\/]/g, ' ').replace(/\+s/, ' ').split(' '), (word) ->
      if stopWordRegex.test word then null else word

  analysedWords: ->
    @get 'analysedWords'

  getText: ->
    @get('displayText') ? @buildDisplayText()

  getDateTime: ->
    new Date(@get 'created_at')

  getDate: ->
    date = @getDateTime()
    date.setHours(0, 0, 0, 0)
    date

  getUrl: ->
    "http://twitter.com/#!/#{@get('user').id_str}/status/#{@get 'id_str'}"

  isConversation: ->
    @get('in_reply_to_status_id')?

  @emptyText: new Array(140 + 1).join(' ')
  @stopWordRegex: /^(.|--|=+|a[’']s|able|about|above|according|accordingly|across|actually|after|afterwards|again|against|ain[’']t|all|allow|allows|almost|alone|along|already|also|although|always|am|among|amongst|an|and|another|any|anybody|anyhow|anyone|anything|anyway|anyways|anywhere|apart|appear|appreciate|appropriate|are|aren[’']t|around|as|aside|ask|asking|associated|at|available|away|awfully|be|became|because|become|becomes|becoming|been|before|beforehand|behind|being|believe|below|beside|besides|best|better|between|beyond|both|brief|but|by|c[’']mon|c[’']s|came|can|can[’']t|cannot|cant|cause|causes|cc|certain|certainly|changes|clearly|co|com|come|comes|concerning|consequently|consider|considering|contain|containing|contains|corresponding|could|couldn[’']t|course|currently|definitely|described|despite|did|didn[’']t|different|do|does|doesn[’']t|doing|don[’']t|done|down|downwards|during|each|edu|eg|eight|either|else|elsewhere|enough|entirely|especially|et|etc|even|ever|every|everybody|everyone|everything|everywhere|ex|exactly|example|except|far|few|fifth|first|five|followed|following|follows|for|former|formerly|forth|four|from|further|furthermore|get|gets|getting|given|gives|go|goes|going|gone|got|gotten|greetings|had|hadn[’']t|happens|hardly|has|hasn[’']t|have|haven[’']t|having|he|he[’']s|hello|help|hence|her|here|here[’']s|hereafter|hereby|herein|hereupon|hers|herself|hi|him|himself|his|hither|hopefully|how|howbeit|however|http|i[’']d|i[’']ll|i[’']m|i[’']ve|ie|if|ignored|immediate|in|inasmuch|inc|indeed|indicate|indicated|indicates|inner|insofar|instead|into|inward|is|isn[’']t|it|it[’']d|it[’']ll|it[’']s|its|itself|just|keep|keeps|kept|know|knows|known|last|lately|later|latter|latterly|least|less|lest|let|let[’']s|like|liked|likely|little|look|looking|looks|ltd|mainly|many|may|maybe|me|mean|meanwhile|merely|might|more|moreover|most|mostly|much|must|my|myself|name|namely|nd|near|nearly|necessary|need|needs|neither|never|nevertheless|new|next|nine|no|nobody|non|none|noone|nor|normally|not|nothing|novel|now|nowhere|obviously|of|off|often|oh|ok|okay|old|on|once|one|ones|only|onto|or|other|others|otherwise|ought|our|ours|ourselves|out|outside|over|overall|own|particular|particularly|per|perhaps|placed|please|plus|possible|presumably|probably|provides|que|quite|qv|rather|rd|re|really|reasonably|regarding|regardless|regards|relatively|respectively|right|rt|said|same|saw|say|saying|says|second|secondly|see|seeing|seem|seemed|seeming|seems|seen|self|selves|sensible|sent|serious|seriously|seven|several|shall|she|should|shouldn[’']t|since|six|so|some|somebody|somehow|someone|something|sometime|sometimes|somewhat|somewhere|soon|sorry|specified|specify|specifying|still|sub|such|sup|sure|t[’']s|take|taken|tell|tends|th|than|thank|thanks|thanx|that|that[’']s|thats|the|their|theirs|them|themselves|then|thence|there|there[’']s|thereafter|thereby|therefore|therein|theres|thereupon|these|they|they[’']d|they[’']ll|they[’']re|they[’']ve|think|third|this|thorough|thoroughly|those|though|three|through|throughout|thru|thus|to|together|too|took|toward|towards|tried|tries|truly|try|trying|twice|two|un|under|unfortunately|unless|unlikely|until|unto|up|upon|us|use|used|useful|uses|using|usually|value|various|very|via|viz|vs|want|wants|was|wasn[’']t|way|we|we[’']d|we[’']ll|we[’']re|we[’']ve|welcome|well|went|were|weren[’']t|what|what[’']s|whatever|when|whence|whenever|where|where[’']s|whereafter|whereas|whereby|wherein|whereupon|wherever|whether|which|while|whither|who|who[’']s|whoever|whole|whom|whose|why|will|willing|wish|with|within|without|won[’']t|wonder|would|would|wouldn[’']t|yes|yet|you|you[’']d|you[’']ll|you[’']re|you[’']ve|your|yours|yourself|yourselves|zero|ab|aber|abgerufen|abgerufene|abgerufener|abgerufenes|acht|alle|allein|allem|allen|aller|allerdings|allerlei|alles|allgemein|allmählich|allzu|als|alsbald|also|am|an|ander|andere|anderem|anderen|anderer|andererseits|anderes|anderm|andern|andernfalls|anders|anerkannt|anerkannte|anerkannter|anerkanntes|anfangen|anfing|angefangen|angesetze|angesetzt|angesetzten|angesetzter|ansetzen|anstatt|arbeiten|auch|auf|aufgehört|aufgrund|aufhören|aufhörte|aufzusuchen|aus|ausdrücken|ausdrückt|ausdrückte|ausgenommen|ausser|ausserdem|author|autor|außen|außer|außerdem|außerhalb|bald|bearbeite|bearbeiten|bearbeitete|bearbeiteten|bedarf|bedurfte|bedürfen|befragen|befragte|befragten|befragter|begann|beginnen|begonnen|behalten|behielt|bei|beide|beiden|beiderlei|beides|beim|beinahe|beitragen|beitrugen|bekannt|bekannte|bekannter|bekennen|benutzt|bereits|berichten|berichtet|berichtete|berichteten|besonders|besser|bestehen|besteht|beträchtlich|bevor|bezüglich|bietet|bin|bis|bis|bisher|bislang|bist|bleiben|blieb|bloss|bloß|brachte|brachten|brauchen|braucht|bringen|bräuchte|bsp\.|bzw|böden|ca\.|da|dabei|dadurch|dafür|dagegen|daher|dahin|damals|damit|danach|daneben|dank|danke|danken|dann|dannen|daran|darauf|daraus|darf|darfst|darin|darum|darunter|darüber|darüberhinaus|das|dass|dasselbe|davon|davor|dazu|daß|dein|deine|deinem|deinen|deiner|deines|dem|demnach|demselben|den|denen|denn|dennoch|denselben|der|derart|derartig|derem|deren|derer|derjenige|derjenigen|derselbe|derselben|derzeit|des|deshalb|desselben|dessen|desto|deswegen|dich|die|diejenige|dies|diese|dieselbe|dieselben|diesem|diesen|dieser|dieses|diesseits|dinge|dir|direkt|direkte|direkten|direkter|doch|doppelt|dort|dorther|dorthin|drauf|drei|dreißig|drin|dritte|drunter|drüber|du|dunklen|durch|durchaus|durfte|durften|dürfen|dürfte|eben|ebenfalls|ebenso|ehe|eher|eigenen|eigenes|eigentlich|ein|einbaün|eine|einem|einen|einer|einerseits|eines|einfach|einführen|einführte|einführten|eingesetzt|einig|einige|einigem|einigen|einiger|einigermaßen|einiges|einmal|eins|einseitig|einseitige|einseitigen|einseitiger|einst|einstmals|einzig|ende|entsprechend|entweder|er|ergänze|ergänzen|ergänzte|ergänzten|erhalten|erhielt|erhielten|erhält|erneut|erst|erste|ersten|erster|eröffne|eröffnen|eröffnet|eröffnete|eröffnetes|es|etc|etliche|etwa|etwas|euch|euer|eure|eurem|euren|eurer|eures|fall|falls|fand|fast|ferner|finden|findest|findet|folgende|folgenden|folgender|folgendes|folglich|fordern|fordert|forderte|forderten|fortsetzen|fortsetzt|fortsetzte|fortsetzten|fragte|frau|frei|freie|freier|freies|fuer|fünf|für|gab|ganz|ganze|ganzem|ganzen|ganzer|ganzes|gar|gbr|geb|geben|geblieben|gebracht|gedurft|geehrt|geehrte|geehrten|geehrter|gefallen|gefiel|gefälligst|gefällt|gegeben|gegen|gehabt|gehen|geht|gekommen|gekonnt|gemacht|gemocht|gemäss|genommen|genug|gern|gesagt|gesehen|gestern|gestrige|getan|geteilt|geteilte|getragen|gewesen|gewissermaßen|gewollt|geworden|ggf|gib|gibt|gibt[’']s|gleich|gleichwohl|gleichzeitig|glücklicherweise|gmbh|gratulieren|gratuliert|gratulierte|gute|guten|gängig|gängige|gängigen|gängiger|gängiges|gänzlich|hab|habe|haben|haette|halb|hallo|hast|hat|hatte|hatten|hattest|hattet|heraus|herein|heute|heutige|hier|hiermit|hiesige|hin|hinein|hinten|hinter|hinterher|hoch|hundert|hätt|hätte|hätten|höchstens|ich|igitt|ihm|ihn|ihnen|ihr|ihre|ihrem|ihren|ihrer|ihres|im|immer|immerhin|important|in|indem|indessen|info|infolge|innen|innerhalb|ins|insofern|inzwischen|irgend|irgendeine|irgendwas|irgendwen|irgendwer|irgendwie|irgendwo|ist|ja|je|jede|jedem|jeden|jedenfalls|jeder|jederlei|jedes|jedoch|jemand|jene|jenem|jenen|jener|jenes|jenseits|jetzt|jährig|jährige|jährigen|jähriges|kam|kann|kannst|kaum|kein|keine|keinem|keinen|keiner|keinerlei|keines|keines|keineswegs|klar|klare|klaren|klares|klein|kleinen|kleiner|kleines|koennen|koennt|koennte|koennten|komme|kommen|kommt|konkret|konkrete|konkreten|konkreter|konkretes|konnte|konnten|könn|können|könnt|könnte|könnten|künftig|lag|lagen|langsam|lassen|laut|lediglich|leer|legen|legte|legten|leicht|leider|lesen|letze|letzten|letztendlich|letztens|letztes|letztlich|lichten|liegt|liest|links|längst|längstens|mache|machen|machst|macht|machte|machten|mag|magst|mal|man|manche|manchem|manchen|mancher|mancherorts|manches|manchmal|mann|margin|mehr|mehrere|mein|meine|meinem|meinen|meiner|meines|meist|meiste|meisten|meta|mich|mindestens|mir|mit|mithin|mochte|morgen|morgige|muessen|muesst|muesste|muss|musst|musste|mussten|muß|mußt|möchte|möchten|möchtest|mögen|möglich|mögliche|möglichen|möglicher|möglicherweise|müssen|müsste|müssten|müßt|müßte|nach|nachdem|nacher|nachhinein|nacht|nahm|natürlich|neben|nebenan|nehmen|nein|neu|neue|neuem|neuen|neuer|neues|neun|nicht|nichts|nie|niemals|niemand|nimm|nimmer|nimmt|nirgends|nirgendwo|noch|nun|nur|nutzen|nutzt|nutzung|nächste|nämlich|nötigenfalls|nützt|ob|oben|oberhalb|obgleich|obschon|obwohl|oder|oft|ohne|per|pfui|plötzlich|pro|reagiere|reagieren|reagiert|reagierte|rechts|regelmäßig|rief|rund|sage|sagen|sagt|sagte|sagten|sagtest|sang|sangen|schlechter|schließlich|schnell|schon|schreibe|schreiben|schreibens|schreiber|schwierig|schätzen|schätzt|schätzte|schätzten|sechs|sect|sehe|sehen|sehr|sehrwohl|seht|sei|seid|sein|seine|seinem|seinen|seiner|seines|seit|seitdem|seite|seiten|seither|selber|selbst|senke|senken|senkt|senkte|senkten|setzen|setzt|setzte|setzten|sich|sicher|sicherlich|sie|sieben|siebte|siehe|sieht|sind|singen|singt|so|sobald|sodaß|soeben|sofern|sofort|sog|sogar|solange|solc hen|solch|solche|solchem|solchen|solcher|solches|soll|sollen|sollst|sollt|sollte|sollten|solltest|somit|sondern|sonst|sonstwo|sooft|soviel|soweit|sowie|sowohl|spielen|später|startet|startete|starteten|statt|stattdessen|steht|steige|steigen|steigt|stets|stieg|stiegen|such|suchen|sämtliche|tages|tat|tatsächlich|tatsächlichen|tatsächlicher|tatsächliches|tausend|teile|teilen|teilte|teilten|titel|total|trage|tragen|trotzdem|trug|trägt|tun|tust|tut|txt|tät|ueber|um|umso|unbedingt|und|ungefähr|unmöglich|unmögliche|unmöglichen|unmöglicher|unnötig|uns|unse|unsem|unsen|unser|unser|unsere|unserem|unseren|unserer|unseres|unserm|unses|unten|unter|unterbrach|unterbrechen|unterhalb|unwichtig|usw|vergangen|vergangene|vergangener|vergangenes|vermag|vermutlich|vermögen|verrate|verraten|verriet|verrieten|version|versorge|versorgen|versorgt|versorgte|versorgten|versorgtes|veröffentlichen|veröffentlicher|veröffentlicht|veröffentlichte|veröffentlichten|veröffentlichtes|viel|viele|vielen|vieler|vieles|vielleicht|vielmals|vier|vollständig|vom|von|vor|voran|vorbei|vorgestern|vorher|vorne|vorüber|völlig|wachen|waere|wann|war|waren|warst|warum|was|weder|weg|wegen|weil|weiter|weitere|weiterem|weiteren|weiterer|weiteres|weiterhin|weiß|welche|welchem|welchen|welcher|welches|wem|wen|wenig|wenige|weniger|wenigstens|wenn|wenngleich|wer|werde|werden|werdet|weshalb|wessen|wichtig|wie|wieder|wieso|wieviel|wiewohl|will|willst|wir|wird|wirklich|wirst|wo|wodurch|wogegen|woher|wohin|wohingegen|wohl|wohlweislich|wolle|wollen|wollt|wollte|wollten|wolltest|wolltet|womit|woraufhin|woraus|worin|wurde|wurden|während|während|währenddessen|wär|wäre|wären|würde|würden|z\.B\.|zahlreich|zehn|zeitweise|ziehen|zieht|zog|zogen|zu|zudem|zuerst|zufolge|zugleich|zuletzt|zum|zumal|zur|zurück|zusammen|zuviel|zwanzig|zwar|zwei|zwischen|zwölf|ähnlich|übel|über|überall|überallhin|überdies|übermorgen|übrig|übrigens)$/
