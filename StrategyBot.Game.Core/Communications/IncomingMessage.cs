using MongoDB.Bson;

namespace StrategyBot.Game.Logic.Communications
{
    public class IncomingMessage
    {
        public string Text { get; set; }
        
        public ObjectId PlayerId { get; set; }
    }
}