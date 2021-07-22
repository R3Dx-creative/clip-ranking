(ns clip-ranking.core)

(defrecord Clip [dir file like dest])

(defn ranking [rule ranks]
  (let [ranked
        (fn [i clip]
          (->> ranks
               (some (fn [[dir condition]]
                       (when (condition i clip) dir)))
               (assoc clip :dest)))]
    (fn [clips]
      (->> clips
           (filter rule)
           (map-indexed (fn [i clip] (ranked i clip)))))))