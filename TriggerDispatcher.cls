public class TriggerDispatcher {
    public static void Run(ITriggerHandler handler) {
        if (Trigger.IsBefore) {
            if (Trigger.IsInsert)
                handler.BeforeInsert(Trigger.new);

            if (Trigger.IsUpdate)
                handler.BeforeUpdate(Trigger.newMap, Trigger.oldMap);

            if (Trigger.IsDelete)
                handler.BeforeDelete(Trigger.oldMap);
        }

        if (Trigger.IsAfter) {
            if (Trigger.IsInsert)
                handler.AfterInsert(Trigger.newMap);

            if (Trigger.IsUpdate)
                handler.AfterUpdate(Trigger.newMap, Trigger.oldMap);

            if (Trigger.IsDelete)
                handler.AfterDelete(Trigger.oldMap);

            if (Trigger.isUndelete)
                handler.AfterUndelete(Trigger.oldMap);
        }
    }
}