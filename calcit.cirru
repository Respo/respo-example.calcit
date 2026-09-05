
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
                  states $ unsafe-coerce (read-field store :states) 'Map
                  cursor $ or (read-field states :cursor) ([])
                  state $ unsafe-coerce
                    or (read-field states :data)
                      {} $ :content |
                    , 'Map
                  log-plugin $ use-log (>> states :cont) (read-field state :content)
                [] (read-field log-plugin :effect)
                  div
                    {} $ :style
                      merge (style-map ui/global) (style-map ui/column)
                        style-map $ {} (:padding 8)
                    div ({})
                      input $ {}
                        :value $ read-field state :content
                        :placeholder |Content
                        :style $ merge ui/expand ui/input
                        :on-input $ fn (e d!)
                          d! cursor $ assoc state :content (read-field e :value)
                      =< 8 nil
                      button $ {} (:style ui/button) (:inner-text |Run)
                        :on-click $ fn (e d!)
                          println $ read-field state :content
                      =< 24 nil
                      <> $ str "|Counter: " (read-field store :counter)
                      =< 8 nil
                      button $ {} (:style ui/button) (:inner-text "|Inc counter")
                        :on-click $ fn (e d!) (d! :inc nil)
                    =< nil 16
                    memof1-call comp-demo (>> states :a) |A 10
                    memof1-call comp-demo (>> states :a2) |A2 10
                    memof1-call comp-demo (>> states :a3) |A3 10
                    memof1-call comp-demo (>> states :a4) |A4 10
                    memof1-call comp-demo (>> states :a5) |A5 10
                    read-field log-plugin :ui
          :examples $ []
          :schema $ :: 'Dynamic
        'comp-demo $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-demo (states mark level)
              let
                  states-map $ unsafe-coerce states 'Map
                  cursor $ read-field states-map :cursor
                  state $ unsafe-coerce
                    or (read-field states-map :data)
                      {} $ :draft |
                    , 'Map
                  log-plugin $ memof1-call use-log (>> states :demo) |DEMO
                println |Called: mark
                [] (read-field log-plugin :effect)
                  div
                    {} $ :style
                      {}
                        :border $ str "|1px solid " (hsl 0 0 90)
                        :padding 8
                    input $ {}
                      :value $ &map:get state :draft
                      :style ui/input
                      :on-input $ fn (e d!)
                        d! cursor $ assoc state :draft (read-field e :value)
                    <> $ str "|This a demo: " mark
                    pre $ {}
                      :style $ {}
                        :background $ hsl 0 0 95
                        :padding "|4px 8px"
                      :inner-text $ .trim (format-cirru-edn state)
                    ; if (> level 10)
                      comp-demo (>> states level) (str |M- level) (dec level)
                    read-field log-plugin :ui
          :examples $ []
          :schema $ :: 'Dynamic
        'effect-log $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defeffect effect-log (mark) (action el at?) (js/console.log "|Effect happen:" mark action)
          :examples $ []
          :schema $ :: 'Dynamic
        'read-field $ %{} 'CodeEntry (:doc "|Read an open Map or Struct field at the UI boundary.")
          :code $ quote
            defn read-field (value field)
              if (struct? value) (&struct:get value field) (&map:get value field)
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'Dynamic)
              :args $ [] 'Dynamic 'Tag
        'style-map $ %{} 'CodeEntry (:doc "|Normalize heterogeneous Respo style values.")
          :code $ quote
            defn style-map (value) (unsafe-coerce value 'Map)
          :examples $ []
          :schema $ :: 'Fn
            {} (:return 'Map)
              :args $ [] 'Dynamic
        'use-log $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defn use-log (states mark)
              let
                  states-map $ unsafe-coerce states 'Map
                  cursor $ read-field states-map :cursor
                  state $ unsafe-coerce
                    or (read-field states-map :data)
                      {} $ :draft |
                    , 'Map
                {}
                  :ui $ div ({})
                    <> $ str "|LOG ::: " mark "| :: " (read-field state :draft)
                    input $ {}
                      :value $ read-field state :draft
                      :style ui/input
                      :on-input $ fn (e d!)
                        d! cursor $ assoc state :draft (read-field e :value)
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
            memof.once :refer $ memof1-call
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
                :states $ let[] (cursor s) data (update-states store cursor s)
                :inc $ update store :counter inc
                op store
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.updater $ :require
            respo.cursor :refer $ update-states
