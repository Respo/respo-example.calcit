
{} (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:reload-fn |app.main/reload!)
    :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/
    :version |0.0.1
  :files $ {}
    |app.comp.container $ {}
      :ns $ quote
        ns app.comp.container $ :require (respo-ui.core :as ui)
          respo.core :refer $ defcomp defeffect <> >> div button textarea span input pre
          respo.comp.space :refer $ =<
          app.config :refer $ dev?
          respo.util.format :refer $ hsl
      :defs $ {}
        |comp-container $ quote
          defcomp comp-container (store)
            let
                states $ :states store
                cursor $ or (:cursor states) ([])
                state $ or (:data states)
                  {} $ :content "\""
              div
                {} $ :style
                  merge ui/global ui/column $ {} (:padding 8)
                div ({})
                  input $ {}
                    :value $ :content state
                    :placeholder "\"Content"
                    :style $ merge ui/expand ui/input
                    :on-input $ fn (e d!)
                      d! cursor $ assoc state :content (:value e)
                  =< 8 nil
                  button $ {} (:style ui/button) (:inner-text "\"Run")
                    :on-click $ fn (e d!)
                      println $ :content state
                  =< 24 nil
                  <> $ str "\"Counter: " (:counter store)
                  =< 8 nil
                  button $ {} (:style ui/button) (:inner-text "\"Inc counter")
                    :on-click $ fn (e d!) (d! :inc nil)
                =< nil 16
                comp-demo (>> states :a) "\"A" 10
        |comp-demo $ quote
          defn comp-demo (states mark level)
            let
                cursor $ :cursor states
                state $ or (:data states)
                  {} $ :draft "\""
              div
                {} $ :style
                  {}
                    :border $ str "\"1px solid " (hsl 0 0 90)
                    :padding 8
                input $ {}
                  :value $ &map:get state :draft
                  :style ui/input
                  :on-input $ fn (e d!)
                    d! cursor $ assoc state :draft (-> e :event .-target .-value)
                <> $ str "\"This a demo: " mark
                pre $ {}
                  :style $ {}
                    :background $ hsl 0 0 95
                    :padding "\"4px 8px"
                  :inner-text $ .trim (format-cirru-edn state)
                ; if (> level 10)
                  comp-demo (>> states level) (str "\"M-" level) (dec level)
      :proc $ quote ()
    |app.config $ {}
      :ns $ quote (ns app.config)
      :defs $ {}
        |dev? $ quote (def dev? true)
        |site $ quote
          def site $ {} (:storage-key "\"workflow")
      :proc $ quote ()
    |app.main $ {}
      :ns $ quote
        ns app.main $ :require
          respo.core :refer $ render! clear-cache!
          app.comp.container :refer $ comp-container
          app.updater :refer $ updater
          app.schema :as schema
          app.config :as config
      :defs $ {}
        |dispatch! $ quote
          defn dispatch! (op op-data)
            when
              and config/dev? $ not= op :states
              println "\"Dispatch:" op $ ; op-data
            let
                op-id $ generate-id!
                op-time $ js/Date.now
              reset! *store $ updater @*store op op-data op-id op-time
        |*store $ quote (defatom *store schema/store)
        |main! $ quote
          defn main! () (load-console-formatter!)
            println "\"Running mode:" $ if config/dev? "\"dev" "\"release"
            render-app!
            add-watch *store :changes $ fn (store prev) (render-app!)
            println "|App started."
        |render-app! $ quote
          defn render-app! () $ render! mount-target (comp-container @*store) dispatch!
        |reload! $ quote
          defn reload! () (clear-cache!) (remove-watch *store :changes)
            add-watch *store :changes $ fn (store prev) (render-app!)
            render-app!
        |mount-target $ quote
          def mount-target $ .querySelector js/document |.app
      :proc $ quote ()
    |app.schema $ {}
      :ns $ quote (ns app.schema)
      :defs $ {}
        |store $ quote
          def store $ {}
            :states $ {}
              :cursor $ []
            :counter 0
      :proc $ quote ()
    |app.updater $ {}
      :ns $ quote
        ns app.updater $ :require
          respo.cursor :refer $ update-states
      :defs $ {}
        |updater $ quote
          defn updater (store op data op-id op-time)
            case op
              :states $ update-states store data
              :inc $ update store :counter inc
              op store
      :proc $ quote ()
