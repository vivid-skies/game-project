using System;
using Godot;
using System.IO;

namespace Osus.OsuLib.utils
{
    public partial class Logger
    {
        private static string logFilePath = ProjectSettings.GlobalizePath("user://debug/logs.txt");

        public enum LogLevel
        {
            Debug,
            Info,
            Warning,
            Error
        }

        public static void Log(string message, LogLevel level = LogLevel.Info)
        {
            string timestamp = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            string formattedMessage = $"[{timestamp}] [{level}] {message}";

            // Log to Godot console
            switch (level)
            {
                case LogLevel.Warning:
                case LogLevel.Error:
                    GD.PrintErr(formattedMessage);
                    break;
                default:
                    GD.Print(formattedMessage);
                    break;
            }

            // Log to file
            LogToFile(formattedMessage);
        }

        private static void LogToFile(string message)
        {
            try
            {
                using (StreamWriter writer = new StreamWriter(logFilePath, true))
                {
                    writer.WriteLine(message);
                }
            }
            catch (Exception ex)
            {
                GD.PrintErr($"Failed to write to log file: {ex.Message}");
            }
        }
    }
}
