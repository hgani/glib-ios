class JsonAction_Timeouts_Set: JsonAction {
    override func silentExecute() -> Bool {
        guard let gscreen = screen as? GScreen else {
            GLog.e("Timer is only supported on a GScreen")
            return false
        }

        let intervalInSeconds = Double(spec["interval"].intValue) / 1000.0
        gscreen.scheduleTimer(intervalInSeconds: intervalInSeconds, repeats: spec["repeat"].boolValue) {
            JsonAction.execute(spec: self.spec["onTimeout"], screen: self.screen, creator: self)
        }

        return true
    }
}
