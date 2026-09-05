
{} (:about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --full` first. Manual edits must follow format and schema conventions, then run `calcit edit format`.") (:package |app)
  :entries $ {}
    :default $ {} (:description |Browser-example) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!)
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
                  states $ option:unwrap (get store :states)
                  cursor $ option:unwrap-or (get states :cursor) ([])
                  state $ option:unwrap-or (get states :data)
                    {} $ :content |
                  log-plugin $ use-log (>> states :cont)
                    option:unwrap $ get state :content
                []
                  option:unwrap $ get log-plugin :effect
                  div
                    {} $ :style
                      merge ui/global ui/column $ {} (:padding |8px)
                    div ({})
                      input $ {}
                        :value $ option:unwrap (get state :content)
                        :placeholder |Content
                        :style $ merge ui/expand ui/input
                        :on-input $ fn (e d!)
                          hint-fn $ {} (:return 'Dynamic)
                            :args $ [] 'respo.schema/RespoEvent 'Dynamic
                          let
                              value $ :value e
                            when (string? value)
                              d! cursor $ assoc state :content value
                      =< 8 nil
                      button $ {} (:style ui/button) (:inner-text |Run)
                        :on-click $ fn (e d!)
                          println $ option:unwrap (get state :content)
                      =< 24 nil
                      <> $ str "|Counter: "
                        option:unwrap $ get store :counter
                      =< 8 nil
                      button $ {} (:style ui/button) (:inner-text "|Inc counter")
                        :on-click $ fn (e d!) (d! :inc nil)
                    =< nil 16
                    memof1-call-by :a comp-demo (>> states :a) |A 10
                    memof1-call-by :a2 comp-demo (>> states :a2) |A2 10
                    memof1-call-by :a3 comp-demo (>> states :a3) |A3 10
                    memof1-call-by :a4 comp-demo (>> states :a4) |A4 10
                    memof1-call-by :a5 comp-demo (>> states :a5) |A5 10
                    option:unwrap $ get log-plugin :ui
          :examples $ []
          :schema $ :: 'Dynamic
        'comp-demo $ %{} 'CodeEntry (:doc |)
          :code $ quote
            defcomp comp-demo (states mark level)
              let
                  cursor $ option:unwrap (get states :cursor)
                  state $ option:unwrap-or (get states :data)
                    {} $ :draft |
                  log-plugin $ memof1-call-by cursor use-log (>> states :demo) |DEMO
                println |Called: mark
                []
                  option:unwrap $ get log-plugin :effect
                  div
                    {} $ :style
                      {}
                        :border $ str "|1px solid " (hsl 0 0 90)
                        :padding 8
                    input $ {}
                      :value $ option:unwrap (get state :draft)
                      :style ui/input
                      :on-input $ fn (e d!)
                        hint-fn $ {} (:return 'Dynamic)
                          :args $ [] 'respo.schema/RespoEvent 'Dynamic
                        let
                            value $ :value e
                          when (string? value)
                            d! cursor $ assoc state :draft value
                    <> $ str "|This a demo: " mark
                    pre $ {}
                      :style $ {}
                        :background $ hsl 0 0 95
                        :padding "|4px 8px"
                      :inner-text $ .trim (format-cirru-edn state)
                    ; if (> level 10)
                      comp-demo (>> states level) (str |M- level) (dec level)
                    option:unwrap $ get log-plugin :ui
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
                  cursor $ option:unwrap (get states :cursor)
                  state $ option:unwrap-or (get states :data)
                    {} $ :draft |
                {}
                  :ui $ div ({})
                    <> $ str "|LOG ::: " mark "| :: "
                      option:unwrap $ get state :draft
                    input $ {}
                      :value $ option:unwrap (get state :draft)
                      :style ui/input
                      :on-input $ fn (e d!)
                        hint-fn $ {} (:return 'Dynamic)
                          :args $ [] 'respo.schema/RespoEvent 'Dynamic
                        let
                            value $ :value e
                          when (string? value)
                            d! cursor $ assoc state :draft value
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
            memof.once :refer $ memof1-call-by
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
            defn dispatch! (op)
              when config/dev? $ println |Dispatch: op
              reset! *store $ updater @*store op
              , &unit
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
            defn reload! () (clear-cache!) (remove-watch *store :changes) (reset-memof1-caches!)
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
            memof.once :refer $ reset-memof1-caches!
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
            defn updater (store op)
              match op
                (:states cursor data) (update-states store cursor data)
                (:inc _) (update store :counter inc)
                _ store
          :examples $ []
          :schema $ :: 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote
          ns app.updater $ :require
            respo.cursor :refer $ update-states
