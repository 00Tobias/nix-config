#!/usr/bin/env bb

(require '[clojure.java.shell :refer [sh]])

(sh "ls")

;; Map
(def mappings
  {:map {:normal [["Return" ["spawn" "wezterm"]]
                  ["Space" ["spawn" "rofi -show drun"]]
                  ;; Focus
                  ["J" ["focus-view" "next"]]
                  ["K" ["focus-view" "previous"]]],
         :locked []}})

;; Colors

;; Start

;; Apply config
;; (sh)
