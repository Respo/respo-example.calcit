
{} (:about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --full` first. Manual edits must follow format and schema conventions, then run `calcit edit format`.") (:package |app)
  :entries $ {}
    :default $ {} (:description |) (:init-fn 'app.main/main!) (:mode :native) (:reload-fn 'app.main/reload!)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/
      :type-slots $ {}
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-container (store)
              let
                  states $ :states store
                  cursor $ or (:cursor states) ([])
                  state $ or (:data states)
                    {} $ :content |
                  log-plugin $ use-log (>> states :cont) (:content state)
                [] (:effect log-plugin)
                  div
                    {} $ :style
                      merge ui/global ui/column $ {} (:padding 8)
                    div ({})
                      input $ {}
                        :value $ :content state
                        :placeholder |Content
                        :style $ merge ui/expand ui/input
                        :on-input $ fn (e d!)
                          d! cursor $ assoc state :content (:value e)
                      =< 8 nil
                      button $ {} (:style ui/button) (:inner-text |Run)
                        :on-click $ fn (e d!)
                          println $ :content state
                      =< 24 nil
                      <> $ str "|Counter: " (:counter store)
                      =< 8 nil
                      button $ {} (:style ui/button) (:inner-text "|Inc counter")
                        :on-click $ fn (e d!) (d! :inc nil)
                    =< nil 16
                    memof-call comp-demo (>> states :a) |A 10
                    memof-call comp-demo (>> states :a2) |A2 10
                    memof-call comp-demo (>> states :a3) |A3 10
                    memof-call comp-demo (>> states :a4) |A4 10
                    memof-call comp-demo (>> states :a5) |A5 10
                    :ui log-plugin
          :examples $ []
          :schema $ :: 'Dynamic
        'comp-demo $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-demo (states mark level)
              let
                  cursor $ :cursor states
                  state $ or (:data states)
                    {} $ :draft |
                  log-plugin $ memof-call use-log (>> states :demo) |DEMO
                println |Called: mark
                [] (:effect log-plugin)
                  div
                    {} $ :style
                      {}
                        :border $ str "|1px solid " (hsl 0 0 90)
                        :padding 8
                    input $ {}
                      :value $ &map:get state :draft
                      :style ui/input
                      :on-input $ fn (e d!)
                        d! cursor $ assoc state :draft (-> e :event .-target .-value)
                    <> $ str "|This a demo: " mark
                    pre $ {}
                      :style $ {}
                        :background $ hsl 0 0 95
                        :padding "|4px 8px"
                      :inner-text $ .trim (format-cirru-edn state)
                    ; if (> level 10)
                      comp-demo (>> states level) (str |M- level) (dec level)
                    :ui log-plugin
          :examples $ []
          :schema $ :: 'Dynamic
        'effect-log $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defeffect effect-log (mark) (action el at?) (js/console.log "|Effect happen:" mark action)
          :examples $ []
          :schema $ :: 'Dynamic
        'use-log $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn use-log (states mark)
              let
                  cursor $ :cursor states
                  state $ or (:data states)
                    {} $ :draft |
                {}
                  :ui $ div ({})
                    <> $ str "|LOG ::: " mark "| :: " (:draft state)
                    input $ {}
                      :value $ :draft state
                      :style ui/input
                      :on-input $ fn (e d!)
                        d! cursor $ assoc state :draft (-> e :event .-target .-value)
                  :effect $ effect-log mark
          :examples $ []
          :schema $ :: 'Dynamic
        'use-plugin $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn use-plugin (mark)
              div
                {} $ :style
                  {} $ :border
                    str "|1px solid " $ hsl 0 0 93
                <> $ str "|log ::: " mark
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.comp.container $ :require (respo-ui.core :as ui)
            respo.core :refer $ defcomp defeffect <> >> div button textarea span input pre
            respo.comp.space :refer $ =<
            app.config :refer $ dev?
            respo.util.format :refer $ hsl
            memof.alias :refer $ memof-call
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote (def dev? true)
          :examples $ []
          :schema $ :: 'Dynamic
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def site $ {} (:storage-key |workflow)
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote (ns app.config)
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*store $ %{} 'CodeEntry (:doc |)
          :code $ quote (defatom *store schema/store)
          :examples $ []
          :schema $ :: 'Dynamic
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn dispatch! (op op-data)
              when
                and config/dev? $ not= op :states
                println |Dispatch: op $ ; op-data
              let
                  op-id $ generate-id!
                  op-time $ js/Date.now
                reset! *store $ updater @*store op op-data op-id op-time
          :examples $ []
          :schema $ :: 'Dynamic
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn main! () (load-console-formatter!)
              println "|Running mode:" $ if config/dev? |dev |release
              render-app!
              add-watch *store :changes $ fn (store prev) (render-app!)
              println "|App started."
          :examples $ []
          :schema $ :: 'Dynamic
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def mount-target $ .querySelector js/document |.app
          :examples $ []
          :schema $ :: 'Dynamic
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn reload! () (clear-cache!) (remove-watch *store :changes)
              add-watch *store :changes $ fn (store prev) (render-app!)
              render-app!
          :examples $ []
          :schema $ :: 'Dynamic
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn render-app! () $ render! mount-target
              w-js-log $ comp-container @*store
              , dispatch!
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.main $ :require
            respo.core :refer $ render! clear-cache!
            app.comp.container :refer $ comp-container
            app.updater :refer $ updater
            app.schema :as schema
            app.config :as config
    'app.schema $ %{} 'FileEntry
      :defs $ {}
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote
            def store $ {}
              :states $ {}
                :cursor $ []
              :counter 0
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote (ns app.schema)
    'app.updater $ %{} 'FileEntry
      :defs $ {}
        'updater $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn updater (store op data op-id op-time)
              case op
                :states $ update-states store data
                :inc $ update store :counter inc
                op store
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.updater $ :require
            respo.cursor :refer $ update-states
