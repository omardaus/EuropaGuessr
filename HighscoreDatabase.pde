
import java.util.ArrayList;
import java.util.Collections;

class HighscoreEntry
{
  public String name;
  public int points;
  public HighscoreEntry(String name, int points)
  {
    this.name = name;
    this.points = points;
  }
}


class HighscoreDatabase
{
  public ArrayList<HighscoreEntry> highscoreEntries = new ArrayList<HighscoreEntry>();
  public String saveLocation = "";

  public HighscoreDatabase(String saveLocation)
  {
    this.saveLocation = saveLocation;
  }

  public boolean AddEntry(String name, int points)
  {
    highscoreEntries.add(new HighscoreEntry(name, points));
    Sort();
    return true;
  }

  public void Sort()
  {
    int[] points = new int[highscoreEntries.size()];
    int index = 0;

    for (HighscoreEntry entry : highscoreEntries)
    {
      points[index] = entry.points;
      ++index;
    }


    points = sort(points);

    int[] newPoints = new int[points.length];

    for (int i = points.length - 1; i >= 0; --i)
    {
      newPoints[i] = points[points.length-1-i];
    }

    for (int i = 0; i < newPoints.length; ++i)
    {
     points[i] = newPoints[i]; 
    }

    HighscoreEntry[] newHighscoreEntries = new HighscoreEntry[highscoreEntries.size()];

    int scoreIndex = 0;

    for (int score : points)
    {
      for (HighscoreEntry entry : highscoreEntries)
      {
        if (entry.points == score)
        {
          newHighscoreEntries[scoreIndex] = new HighscoreEntry(entry.name, score);
        }
      }
      ++scoreIndex;
    }
    
    int i = 0;

    for (HighscoreEntry entry : newHighscoreEntries) {
      highscoreEntries.set(i, entry);
      ++i;
    }
  }

  public void SaveDatabase()
  {
    saveStrings(saveLocation, new String[] {});
    
    PrintWriter writer = createWriter(saveLocation);
    println("save db");
    for (HighscoreEntry entry : highscoreEntries)
    {
      println("save entry");
      writer.println(entry.name + "," + Integer.toString(entry.points));
    }

    writer.flush();
    writer.close();
  }

  public void LoadDatabase()
  {

    String[] strings = loadStrings(saveLocation);
    highscoreEntries.clear();
  

    for (String str : strings)
    {

      if (!str.isEmpty()) {

        String[] strParts = str.split(",");

        
        highscoreEntries.add(new HighscoreEntry(strParts[0], int(strParts[1])));
      }
    }
    
  }
}
