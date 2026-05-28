namespace STEMMA.Domain.Consultas.Entities;

public class Prontuario
{
    public Guid Id { get; private set; }

    public Guid ConsultaId { get; private set; }

    public string Observacoes { get; private set; }

    public string Diagnostico { get; private set; }

    public DateTime DataRegistro { get; private set; }

    protected Prontuario() { }

    public Prontuario(
        Guid consultaId,
        string observacoes,
        string diagnostico)
    {
        Validar(
            consultaId,
            observacoes,
            diagnostico);

        Id = Guid.NewGuid();
        ConsultaId = consultaId;
        Observacoes = observacoes;
        Diagnostico = diagnostico;
        DataRegistro = DateTime.UtcNow;
    }

    public void Atualizar(
        string observacoes,
        string diagnostico)
    {
        Validar(
            ConsultaId,
            observacoes,
            diagnostico);

        Observacoes = observacoes;
        Diagnostico = diagnostico;
    }

    private void Validar(
        Guid consultaId,
        string observacoes,
        string diagnostico)
    {
        if (consultaId == Guid.Empty)
            throw new ArgumentException("Consulta obrigatória.");

        if (string.IsNullOrWhiteSpace(observacoes))
            throw new ArgumentException("Observações obrigatórias.");

        if (string.IsNullOrWhiteSpace(diagnostico))
            throw new ArgumentException("Diagnóstico obrigatório.");
    }
}