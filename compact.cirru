
{} (:package |app)
  :configs $ {} (:init-fn |app.main/main!) (:reload-fn |app.main/reload!)
    :modules $ [] |respo.calcit/ |lilac/ |memof/ |respo-ui.calcit/
    :version |0.0.1
  :files $ {}
    |app.comp.container $ {}
      :ns $ quote
        ns app.comp.container $ :require (respo-ui.core :as ui)
          respo.core :refer $ defcomp defeffect <> >> div button textarea span input
          respo.comp.space :refer $ =<
          app.config :refer $ dev?
      :defs $ {}
        |comp-container $ quote
          defcomp comp-container (store)
            let
                states $ :states store
                cursor $ either (:cursor states) ([])
                state $ either (:data states)
                  {} $ :content "\""
              div
                {} $ :style (merge ui/global ui/row)
                textarea $ {}
                  :value $ :content state
                  :placeholder "\"Content"
                  :style $ merge ui/expand ui/textarea
                    {} $ :height 320
                  :on-input $ fn (e d!)
                    d! cursor $ assoc state :content (:value e)
                =< 8 nil
                div
                  {} $ :style ui/expand
                  =< |8px nil
                  button $ {} (:style ui/button) (:inner-text "\"Run")
                    :on-click $ fn (e d!)
                      println $ :content state
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
              println "\"Dispatch:" op
            let
                op-id $ generate-id!
                op-time $ js/Date.now
              reset! *store $ updater @*store op op-data op-id op-time
        |*store $ quote (defatom *store schema/store)
        |main! $ quote
          defn main! ()
            println "\"Running mode:" $ if config/dev? "\"dev" "\"release"
            render-app! render!
            add-watch *store :changes $ fn (store prev) (render-app! render!)
            println "|App started."
        |render-app! $ quote
          defn render-app! (renderer)
            renderer mount-target (comp-container @*store) dispatch! $ ; \ dispatch! % %2
        |reload! $ quote
          defn reload! () (clear-cache!) (remove-watch *store :changes)
            add-watch *store :changes $ fn (store prev) (render-app! render!)
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
              op store
      :proc $ quote ()
